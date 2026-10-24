#!/system/bin/sh
R=/vendor/lib64
if [ "$(stat -c %s /system/lib64/libc++.so)" = "742128" ]; then
  cp $R/libc++.so /system/lib64/libc++.so.n; chmod 644 /system/lib64/libc++.so.n; mv /system/lib64/libc++.so.n /system/lib64/libc++.so
fi
chmod 755 /vendor/bin/vtsthp
chmod 644 $R/libvts.so $R/libvtsthp.so $R/libexpat.so $R/libsynaHal.so $R/PD2415_MODID*.so 2>/dev/null
setprop vendor.vivo.touch.support.vtsthp_recovery0 1
cd /system/etc/vintf
[ -f manifest.xml.bak ] || cp manifest.xml manifest.xml.bak
busybox sed -i -e 's/version="9.0"/version="8.0"/g' -e 's/ max-level="[0-9]*"//g' manifest.xml manifest/*.xml 2>/dev/null
mkdir -p /vendor/etc/vintf/manifest
for f in manifest/*.xml; do grep -q 'type="device"' $f 2>/dev/null && mv $f /vendor/etc/vintf/manifest/ 2>/dev/null; done
echo LIVEFIX_DONE
