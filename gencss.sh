#!/bin/bash
style="monokai"
formats="html"
for f in ${formats}
do
	pygmentize -f ${f} -S ${style}
done
