
all:<#list packages as package> build-${package.name}</#list> ../../repo/dists/jaunty/j2play/binary-i386/Packages.gz

clean:
	rm *.deb
<#list packages as package>
build-${package.name} : check-${package.name} ${package.name}-${versions[package.name]}.deb

${package.name}-${versions[package.name]}.deb :
	chmod 755 ${package.name}/DEBIAN/p*
	dpkg --build ${package.name}
	mv ${package.name}.deb ${package.name}-${versions[package.name]}.deb
	cp ${package.name}-${versions[package.name]}.deb ../../repo/dists/jaunty/j2play/binary-i386/

check-${package.name} :
	if [ `find ${package.name} -type f -newer ${package.name}-${versions[package.name]}.deb` ]; then rm ${package.name}-${versions[package.name]}.deb; fi

</#list>
../../repo/dists/jaunty/j2play/binary-i386/Packages.gz : <#list packages as package> ${package.name}-${versions[package.name]}.deb</#list>
	cd ../../repo;dpkg-scanpackages -m dists/jaunty/j2play/binary-i386 /dev/null | gzip -9c > dists/jaunty/j2play/binary-i386/Packages.gz
