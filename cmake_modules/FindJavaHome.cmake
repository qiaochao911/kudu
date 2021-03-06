# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# This is an adaptation of Bigtop's bigtop-detect-javahome:
# https://github.com/apache/bigtop/blob/38e1571b2f73bbfa6ab0c01a689fae967b8399d9/bigtop-packages/src/common/bigtop-utils/bigtop-detect-javahome
# (this is the last version to support JDK7).
#
# This module defines
#  JAVA_HOME, directory containing a Java installation
#  JAVA_HOME_FOUND, whether JAVA_HOME has been found

set(JAVA_HOME_CANDIDATES

    # Oracle JDK 8 Candidates
    /usr/java/jdk1.8
    /usr/java/jre1.8
    /usr/lib/jvm/j2sdk1.8-oracle
    /usr/lib/jvm/j2sdk1.8-oracle/jre
    /usr/lib/jvm/java-8-oracle
    /usr/lib/jdk8-latest

    # OpenJDK 8 Candidates
    /usr/lib/jvm/java-1.8.0-openjdk-amd64
    /usr/lib/jvm/java-1.8.0-openjdk-ppc64el
    /usr/lib/jvm/java-1.8.0-openjdk
    /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0

    # Oracle JDK 7 Candidates
    /usr/java/jdk1.7
    /usr/java/jre1.7
    /usr/lib/jvm/j2sdk1.7-oracle
    /usr/lib/jvm/j2sdk1.7-oracle/jre
    /usr/lib/jvm/java-7-oracle
    /usr/lib/jdk7-latest

    # OpenJDK 7 Candidates
    /usr/lib/jvm/java-1.7.0-openjdk
    /usr/lib/jvm/java-7-openjdk-amd64
    /usr/lib/jvm/java-7-openjdk

    # Misc. Candidates
    /usr/java/default
    /usr/lib/jvm/java
    /usr/lib/jvm/jre
    /usr/lib/jvm/default-java
    /usr/lib/jvm/java-openjdk
    /usr/lib/jvm/jre-openjdk)

if (DEFINED ENV{JAVA_HOME})
  set(JAVA_HOME $ENV{JAVA_HOME})
  set(JAVA_HOME_FOUND true)
elseif (APPLE)
  # Use the 'java_home' finder on macOS.
  execute_process(COMMAND /usr/libexec/java_home
                  OUTPUT_VARIABLE JAVA_HOME
                  RESULT_VARIABLE JAVA_HOME_ERROR
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if (JAVA_HOME_ERROR)
    message(FATAL_ERROR "Unable to run /usr/libexec/java_home: ${JAVA_HOME_ERROR}")
  else()
    set(JAVA_HOME_FOUND true)
  endif()
else()
  foreach(CANDIDATE ${JAVA_HOME_CANDIDATES})
    if (IS_DIRECTORY ${CANDIDATE} AND EXISTS ${CANDIDATE}/bin/java)
      set(JAVA_HOME ${CANDIDATE})
      set(JAVA_HOME_FOUND true)
      break()
    endif()
  endforeach()
endif()

if (JAVA_HOME_FOUND AND NOT EXISTS "${JAVA_HOME}/bin/java")
  message(FATAL_ERROR "$JAVA_HOME (${JAVA_HOME}) does not contain bin/java")
endif()

if (DEFINED JavaHome_FIND_REQUIRED AND NOT DEFINED JAVA_HOME_FOUND)
  message(FATAL_ERROR "failed to find JAVA_HOME")
else()
  message("Found JAVA_HOME: ${JAVA_HOME}")
endif()
