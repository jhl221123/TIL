# !/bin/bash
message="[TEST]TIL 작성했습니다."
SLACK_WEBHOOK_URL=$1

curl -H "Content-type: application/json; charset=utf-8" \
    --data '{"author_name": "이준혁", "attachments": [{"text": '"\"${message}\""'}]}' \
    -X POST ${SLACK_WEBHOOK_URL}