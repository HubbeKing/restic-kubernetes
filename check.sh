#!/bin/sh

nice -n ${NICE_ADJUST} ionice -c ${IONICE_CLASS} -n ${IONICE_PRIO} restic check
