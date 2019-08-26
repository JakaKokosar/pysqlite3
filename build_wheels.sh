#!/usr/bin/env bash

set -ex

echo "Building for ${PYBIN}..."

# Compile pysqlite3 wheels
${PYBIN}/pip wheel -w wheelhouse/ .

# Bundle external shared libraries into the wheels
for whl in wheelhouse/pysqlite3*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w wheelhouse/
done

# Make sure the wheel can be installed
${PYBIN}/pip install --user --force-reinstall --find-links wheelhouse pysqlite3

# test if extension installed
${PYBIN}/python -c "import pysqlite3.dbapi2 as sqlite3; print(sqlite3.__file__);"
${PYBIN}/python -c "import pysqlite3.dbapi2 as sqlite3; conn=sqlite3.connect(':memory:'); cursor=conn.cursor(); cursor.execute('CREATE VIRTUAL TABLE testing USING fts5(data);')"

