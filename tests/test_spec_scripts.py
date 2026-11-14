import os
import pathlib
import subprocess
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
BASH = os.environ.get('BASH', 'bash')


class SpecScriptsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = pathlib.Path(self.temp.name)
        self.specs = self.root / 'specs'
        self.specs.mkdir()
        (self.root / 'src').mkdir()
        (self.root / 'src' / 'app.py').touch()
        (self.root / 'test.py').touch()

    def write_spec(self, targets='../src/app.py', body='', closing=True, newline='\n'):
        text = '---\nname: Example\ndescription: Example behavior\ntargets:\n  - ' + targets + '\n'
        if closing:
            text += '---\n'
        text += body
        (self.specs / 'example.spec.md').write_bytes(text.replace('\n', newline).encode())

    def run_script(self, name, expected=0):
        result = subprocess.run(
            [BASH, (ROOT / 'scripts' / name).as_posix(), self.specs.as_posix()],
            text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        return result.stdout

    def test_valid_spec(self):
        self.write_spec(body='[@test] ../test.py\n')
        self.run_script('validate-specs.sh')
        self.run_script('check-spec-links.sh')

    def test_requires_closing_frontmatter(self):
        self.write_spec(closing=False)
        self.run_script('validate-specs.sh', 1)

    def test_crlf_frontmatter_and_links(self):
        self.write_spec(body='[@test] ../test.py\n', newline='\r\n')
        self.run_script('validate-specs.sh')
        self.run_script('check-spec-links.sh')

    def test_quoted_target_paths(self):
        for quote in ['"', "'"]:
            with self.subTest(quote=quote):
                self.write_spec(targets=quote + '../src/app.py' + quote)
                self.run_script('check-spec-links.sh')

    def test_recursive_glob_includes_direct_and_deep_children(self):
        self.write_spec(targets='../src/**/*.py')
        self.run_script('check-spec-links.sh')
        (self.root / 'src' / 'app.py').unlink()
        deep = self.root / 'src' / 'one' / 'two'
        deep.mkdir(parents=True)
        (deep / 'app.py').touch()
        self.run_script('check-spec-links.sh')

    def test_question_mark_and_character_class_globs(self):
        for target in ['../src/ap?.py', '../src/[a-z]pp.py']:
            with self.subTest(target=target):
                self.write_spec(targets=target)
                self.run_script('check-spec-links.sh')

    def test_missing_test_link_without_final_newline(self):
        self.write_spec(body='[@test] ../missing.py')
        self.run_script('check-spec-links.sh', 1)

    def test_missing_targets_and_test_links_still_fail(self):
        self.write_spec(targets='../missing/*.py', body='[@test] ../missing.py\n')
        self.run_script('check-spec-links.sh', 1)


if __name__ == '__main__':
    unittest.main()
