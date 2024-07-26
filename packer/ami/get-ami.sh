#!/bin/bash
manifest.json | jq -r .builds[0].artifact_id |  cut -d':' -f2
