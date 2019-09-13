FROM multiarch/alpine:aarch64-edge 

ENV TZ=Asia/Shanghai

RUN set -eux; \
	#sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
	apk --no-cache --no-progress upgrade; \
	apk --no-cache --no-progress add tzdata; \
	#sed -i 's/mirrors.aliyun.com/dl-cdn.alpinelinux.org/g' /etc/apk/repositories; \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -eux; \
	tag_url="https://api.github.com/repos/liuzhuoling2011/baidupcs-web/releases/latest"; \
	new_ver=$(curl -s ${tag_url} --connect-timeout 10| grep 'tag_name' | cut -d\" -f4); \
	new_ver="v${new_ver##*v}"; \
	wget https://github.com/liuzhuoling2011/baidupcs-web/releases/download/${new_ver}/BaiduPCS-Go-${new_ver}-linux-arm64.zip; \
	unzip BaiduPCS-Go-${new_ver}-linux-arm64.zip; \
        mv BaiduPCS-Go-${new_ver}-linux-arm64/BaiduPCS-Go /usr/local/bin; \
	rm -rf BaiduPCS-Go-${new_ver}-linux-arm64*; \
	chmod +x /usr/local/bin/BaiduPCS-Go

EXPOSE 5299
CMD ["/usr/local/bin/BaiduPCS-Go"]

