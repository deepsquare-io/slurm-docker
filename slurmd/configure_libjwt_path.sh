#! /bin/bash

cat <<\END >/etc/ld.so.conf.d/libjwt.conf
	#libjwt library path
	/usr/local/lib/
END
