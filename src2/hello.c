// Copyright 2012 The Goma Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <stdio.h>
#include <time.h>

int main() {
  printf("Hello world\n");
  time_t start;
  time(&start); 
  while(1) {
    time_t now, later;
    time(&now);
    if (now - start > 60) {
      break;
    }
  }
  return 0;
}
