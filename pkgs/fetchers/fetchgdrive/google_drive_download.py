#!/usr/bin/env python3
import re
import sys
from typing import IO
import requests
from math import ceil


def get_filename(response: requests.Response) -> str | None:
    try:
        cd = response.headers["Content-Disposition"]
        cd = cd[cd.find("filename=") + 10 :]
        cd = cd[: cd.find('"')]
    except IndexError:
        return
    except KeyError:
        return
    return cd


def stream_with_progress(response: requests.Response, output: IO):
    total = int(response.headers.get("content-length", 0)) or None
    if total is None:
        print("Content-Length is not present", file=sys.stderr)
        next_msg = -1
        msg_step = -1
    else:
        msg_step = int(ceil(total / 100))
        next_msg = msg_step

    done = 0
    for chunk in response.iter_content(chunk_size=None):
        output.write(chunk)

        done += len(chunk)
        if total is not None:
            if done > next_msg:
                percentage = round(done / total * 100, 1)
                print(
                    f"{done}/{total} bytes dowloaded ({percentage}%)", file=sys.stderr
                )
                next_msg += (((done - next_msg) / msg_step) + 1) * msg_step


def open_output_file(response: requests.Response):
    filename = get_filename(response) or "output"
    print(filename)
    return open(filename, "wb+")


file_id = sys.argv[1]

download_url = f"https://drive.google.com/uc?export=download&id={file_id}"
print("Fetching initial response", file=sys.stderr)
response = requests.get(download_url, stream=True)

if (
    response.headers["content-type"].startswith("text/html")
    and file_id in response.text
):
    UUID_REGEX = re.compile(
        r'"([0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12})"'
    )
    assert (match := UUID_REGEX.search(response.text))
    (uuid,) = match.groups()

    print("Fetching confirmed response", file=sys.stderr)
    stream_with_progress(
        requests.get(
            "https://drive.usercontent.google.com/download",
            params={"id": file_id, "export": "download", "confirm": "t", "uuid": uuid},
            stream=True,
        ),
        open_output_file(response),
    )
else:
    print("Initial response is not a virus check", file=sys.stderr)
    stream_with_progress(response, open_output_file(response))
