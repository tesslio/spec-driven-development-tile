publish: lint
	tessl tile publish .

lint:
	tessl tile lint .

review:
	tessl skill review skills/requirement-gathering
	tessl skill review skills/spec-writer
	tessl skill review skills/spec-verification
	tessl skill review skills/work-review

eval:
	tessl eval run .
