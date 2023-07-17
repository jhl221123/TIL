# !/bin/bash
message="[TEST]TIL 작성했습니다."

curl -H "Content-type: application/json; charset=utf-8" \
    --data '{"author_name": "이준혁", "attachments": [{"text": '"\"${message}\""'}]}' \
    -X POST ${secrets.SLACK_WEBHOOK_URL}