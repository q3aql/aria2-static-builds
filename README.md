aria2 static builds for GNU/Linux & Windows
===========================================

### aria2 1.34.0 builds (with OpenSSL):

  * **GNU/Linux downloads:**
    * [aria2-1.34.0-linux-gnu-32bit-build1.tar.bz2](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-linux-gnu-32bit-build1.tar.bz2)
    * [aria2-1.34.0-linux-gnu-64bit-build1.tar.bz2](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-linux-gnu-64bit-build1.tar.bz2)
    * [aria2-1.34.0-linux-gnu-arm-rbpi-build1.tar.bz2](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-linux-gnu-arm-rbpi-build1.tar.bz2)

  * **Windows downloads:**
    * [aria2-1.34.0-win-32bit-build1.7z](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-win-32bit-build1.7z)
    * [aria2-1.34.0-win-64bit-build1.7z](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/aria2-1.34.0-win-64bit-build1.7z)

  * **CA-Certificates:**
    * [ca-certificates.crt](https://github.com/q3aql/aria2-static-builds/releases/download/v1.34.0/ca-certificates.crt)

  * **Source code:**
    * [aria2-1.34.0.tar.bz2](https://github.com/tatsuhiro-t/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.bz2)
    * [aria2-1.34.0.tar.gz](https://github.com/tatsuhiro-t/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.gz)
    * [aria2-1.34.0.tar.xz](https://github.com/tatsuhiro-t/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz)

_Note: The error with bcrypt.dll library on Windows XP has been fixed._

### How to install:

  * **GNU/Linux instructions:**
    * Open the terminal.
    * Type the command: `tar jxvf aria2-1.34.0-linux-gnu-[arch]-build1.tar.bz2`
    * Change the directory: `cd aria2-1.34.0-linux-gnu-[arch]-build1`
    * Finally, install the static binary (as root): `make install`

  * **Windows instruccions:**
    * Unzip the package with [7-zip](http://www.7-zip.org/) or [Winrar](http://www.rarlab.com/).
    * Copy the files to a folder. For example: `C:\Program Files\aria2`
    * Add the folder to [PATH](https://www.google.es/search?q=add+folder+to+PATH+on+Windows) variable

### CA Certificates on Windows (HTTPS):

To perform downloads using **HTTPS**, is necessary the ca-certificates. For default, Linux binaries read the certificates from **/etc/ssl/certs/ca-certificates.crt**, but with Windows binaries are necessary define the path of certificates.

You can define the path of the certificates permanently using `aria2.conf` located on `C:\Users\<user>\.aria2\`. If you use Windows XP, the file is located on `C:\Documents and settings\<user>\.aria2\`. For example, you just have to add the following line:

`ca-certificate=C:\Program Files\aria2\certs\ca-certificates.crt`

If you prefer load the certificates manually, you can use the following command:

`C:\PATH\> aria2c --ca-certificate=<PATH-TO-CERTIFICATE> <URL>`

Also, is possible disable the use of certificates with the following command:

`C:\PATH\> aria2c --check-certificate=false <URL>`

### Used external libraries:

  * http://www.zlib.net/
  * http://expat.sourceforge.net/
  * http://c-ares.haxx.se/
  * http://www.sqlite.org/
  * http://www.openssl.org/
  * http://www.libssh2.org/

### External links:

  * [aria2 homepage](https://aria2.github.io/)
  * [aria2 documentation](https://aria2.github.io/manual/en/html/)
  * [aria2 source code (Github)](https://github.com/aria2/aria2)
