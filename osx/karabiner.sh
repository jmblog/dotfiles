#!/usr/bin/env bash

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set repeat.wait 20
/bin/echo -n .
$cli set repeat.initial_wait 300
/bin/echo -n .
$cli set remap.jis_unify_kana_to_eisuu 1
/bin/echo -n .
$cli set remap.jis_unify_eisuu_to_kana 1
/bin/echo -n .
/bin/echo
