#!/usr/bin/env python
import time
import sys
from datetime import datetime

unixEpoch = datetime(year=1970, month=1, day=1)
iPhoneEpoch = datetime(year=2001, month=1, day=1)
epochDelta = iPhoneEpoch - unixEpoch
epochDeltaTimestamp = epochDelta.days * 60 * 60 * 24

date = datetime.fromtimestamp(int(sys.argv[1]) + epochDeltaTimestamp)
print(date)
