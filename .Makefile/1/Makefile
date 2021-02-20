MAKEFILES_DIR=~/.makefiles
TABS=3

AWS_ENV=prd # prd | stg
AWS_FMT=table # table | text | json | yaml | yaml-stream

# * Please set the MACKEREL_API_KEY variable
MACKEREL_URL=https://mackerel.io
MACKEREL_FMT=json

# * Please set the KINTONE_API_KEY variable

SSH_KEY=~/.secret/ssh_id_rsa
SSH_TMP=/tmp/ssh
SSH_FILE=${MAKEFILES_DIR}/ssh

validate:
	@echo "validation complete."

#------------------------------------------------------------------------------#
# AWS CLI
#------------------------------------------------------------------------------#
aws/whoami:
	@aws sts get-caller-identity --profile ${AWS_ENV} --output ${AWS_FMT}

aws/all_instances:
	@aws ec2 describe-instances --profile ${AWS_ENV} \
    --output ${AWS_FMT} \
    --query ' \
		  Reservations[].Instances[].{ \
			  ID: InstanceId, \
	      Hostname: PublicDnsName, \
				PrivateIp: PrivateIpAddress, \
				Name: Tags[?Key==`Name`].Value | [0], \
				Type: InstanceType, \
				Platform: Platform || `Linux` \
			}'

aws/running_instances:
	@aws ec2 describe-instances --profile ${AWS_ENV} \
    --filter Name=instance-state-name,Values=running \
    --output ${AWS_FMT} \
    --query ' \
		  Reservations[].Instances[].{ \
			  ID: InstanceId, \
	      Hostname: PublicDnsName, \
				Name: Tags[?Key==`Name`].Value | [0], \
				Type: InstanceType, \
				Platform: Platform || `Linux` \
			}'

aws/running_linux_instances:
	@aws ec2 describe-instances --profile ${AWS_ENV} \
    --filter Name=instance-state-name,Values=running \
    --output ${AWS_FMT} \
    --query ' \
		  Reservations[].Instances[].{ \
			  ID: InstanceId, \
	      Hostname: PublicDnsName, \
				PrivateIp: PrivateIpAddress, \
				Name: Tags[?Key==`Name`].Value | [0], \
				Type: InstanceType, \
				Platform: Platform || `Linux` \
			}'

aws/sg_rules:
	@aws ec2 describe-security-groups \
		--profile ${AWS_ENV} \
    --output ${AWS_FMT} \
    --query "SecurityGroups[].IpPermissions[].[FromPort,ToPort,IpProtocol,join(',',IpRanges[].CidrIp)]"

#------------------------------------------------------------------------------#
# MACKEREL
#------------------------------------------------------------------------------#
mackerel/hostnames:
	@curl -H "X-Api-Key: ${MACKEREL_API_KEY}" ${MACKEREL_URL}/api/v0/hosts | \ 
	  jq -r '.hosts[]|[.name]|@${MACKEREL_FMT}'

#------------------------------------------------------------------------------#
# KINTONE
#------------------------------------------------------------------------------#
kintone/records:
	@curl -H "X-Cybozu-API-Token:${kintone_api_key}" \
		https://cuebic-ictc.cybozu.com/k/v1/records.json\?app=30 | \
		jq -r ' \
		  .records[].ec2_instance_name| [ \
				.type, \
				.value, \
	   	]|@csv'

#------------------------------------------------------------------------------#
# SSH
#------------------------------------------------------------------------------#
ssh/create:
	@tabs ${TABS}
	@if [ -f ${SSH_FILE} ]; then rm -f ${SSH_FILE}; fi
	@make aws/running_linux_instances AWS_FMT=json 2>/dev/null | \
		jq -r '.[]|select(.Platform=="Linux")|[.Name,.PrivateIp]|@csv' > ${SSH_TMP}
	@while read line; do echo $${line},${SSH_KEY} | \
		sed 's/"//g' | \
		awk -F',' '{gsub(" ", "_", $$1);printf "ssh/%s:\n\t@ssh -i %s centos@%s\n\n",$$1,$$3,$$2}' >> ${SSH_FILE}; \
	  done < ${SSH_TMP}

ssh/unique_check:
	@grep ${SSH_FILE}|sort|uniq -d

ssh/portal_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.16

ssh/hop-job.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.87

ssh/hop-job.com.doctor_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.100

ssh/hop-job.com.old_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.43

ssh/hop-job.com.it-engineer_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.59

ssh/hop-job.com.doctor_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.60

ssh/cuem-log.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.117

ssh/daily.report_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.135

ssh/credit-or-cashing.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.81

ssh/creditcard-seeker.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.88

ssh/creditcard-fun.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.90

ssh/xn--t8j6c6de2351bzzc5r8m.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.99

ssh/waterserver-mizu.com.cia_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.101.79

ssh/ict_ec2_dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.101.196

ssh/cmc_ecs_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.129.143

ssh/cnt-coi-web:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.11.146

ssh/saimu-madoguchi.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.106

ssh/saimu-syakkin0.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.108

ssh/intame.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.118

ssh/c3m_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.46

ssh/datsu-mode.com.db_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.122

ssh/ii-hikkoshi.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.127

ssh/cuebic.co.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.223

ssh/creditcard-get.net.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.102

ssh/datsu-mode.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.11

ssh/datsu-mode.com.db_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.242

ssh/creditcard-get.net.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.89

ssh/kadode-divorce.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.61

ssh/cardloan-farm.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.94

ssh/pol_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.126

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com.column_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.203

ssh/momo-and-ume.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.52

ssh/hop-job.com.it-engineer_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.110

ssh/machineslikeus.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.231

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com.column_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.152

ssh/kou2jiko-sos.com.lp.sp.jiriki_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.26

ssh/waterserver-mizu.com.lp.old_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.240

ssh/hop-job.com.pharmacist_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.130

ssh/xn--u8jvc1drby660ajea95wk08b0s0b5qybrha279c.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.83

ssh/fundavi.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.29

ssh/coinge.jp_ec2_prdold:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.21

ssh/fx-cube.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.184

ssh/cnt-coi-stg01:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.110.10

ssh/twiiter_ecs_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.89

ssh/coinge.jp_ec2_devold:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.45

ssh/ia_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.201

ssh/pulse_ecs_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.93

ssh/cia.db_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.231

ssh/cia_ecs_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.240

ssh/enesuke.jp.re9_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.124

ssh/supple-life.com.denshichi_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.155

ssh/supple-life.com.nyo-san_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.156

ssh/supple-life.com.kettou_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.157

ssh/supple-life.com.denshichi_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.221

ssh/supple-life.com.nyo-san_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.220

ssh/supple-life.com.kettou_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.223

ssh/fx-cube.jp.old_ec2_dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.233

ssh/cia.db_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.73

ssh/cia_ecs_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.109

ssh/cmc_ecs_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.82

ssh/cia.cuebic-ictc.work_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.127

ssh/cia.cuebic-ictc.work_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.110.220

ssh/waterserver.info.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.95

ssh/waterserver-mizu.com.payplan_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.250

ssh/hop-job.com.pharmacist.top_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.4

ssh/onakamagate_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.55

ssh/creditcard-view.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.68

ssh/creditcard-view.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.157

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com_ec2_prdold:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.16

ssh/nurse-cube.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.91

ssh/hop-job.com.pharmacist_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.78

ssh/nurse-cube.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.174

ssh/proxy1_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.164

ssh/hop-job.com.pharmacist.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.161

ssh/saimu-syakkin.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.84

ssh/hop-job.com.job-change.old_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.214

ssh/hop-job.com.nurse_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.213

ssh/saimu-soudan-t.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.208

ssh/home-onayami.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.150

ssh/saimu-soudan-m.com.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.153

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.19

ssh/saimuseiri-blog.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.30

ssh/xn--1cki9mlb6771a4yych82a30l.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.80

ssh/hop-job.com.job-change_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.189

ssh/proxy2_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.46

ssh/supple-life.com.nokogiri_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.155

ssh/waterserver-mizu.com.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.90

ssh/waterserver-mizu.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.21

ssh/cuebic.co.jp.your.select_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.189

ssh/hanyouka_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.220

ssh/waterserver.info.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.195

ssh/hop-job.com.nurse_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.211

ssh/bst_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.154

ssh/cmc.gem_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.5

ssh/cuebic.co.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.139

ssh/cuebic.co.jp.your.select_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.136

ssh/jobbuddy-career.com.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.88

ssh/cuebic-newgrads.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.174

ssh/cuebic-intern.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.12

ssh/jobbuddy-career.com.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.192

ssh/support-students.cuebic.co.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.6

ssh/intame.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.45

ssh/waterserver-mizu.com.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.18

ssh/gakuchika.net_ec2_prd_old:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.73

ssh/waterserver-mizu.com.willgate_ec2_devw:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.39

ssh/cosme-choice.com.rank01_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.59

ssh/altalk.ai_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.55

ssh/hakam.org_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.132

ssh/momo-and-ume.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.185

ssh/saimu-soudan-m.com.lp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.150

ssh/tantei-media.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.35

ssh/xn--u8jvc1drby660ajea95wk08b0s0b5qybrha279c.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.169

ssh/souzoku-q.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.224

ssh/chawengvilla.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.200

ssh/saimu-madoguchi.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.115

ssh/saimu-soudan-t.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.64

ssh/kou2jiko-sos.com.lp.sp.jiriki_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.206

ssh/pitatt.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.204

ssh/cbc-in-log01:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.129

ssh/harae71.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.138

ssh/enesuke.jp.re9_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.246

ssh/sim-book-s.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.252

ssh/www.wcce8.org_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.93

ssh/creditcard-get.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.248

ssh/saimu-simulation.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.254

ssh/cbc-in-graph01:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.36

ssh/career-ippo.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.18

ssh/watashino-bengoshi.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.7

ssh/creditcard-fun.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.11

ssh/kadode-divorce.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.165

ssh/fundavi.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.151

ssh/home-onayami.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.158

ssh/ii-hikkoshi.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.109

ssh/ECS_Instance_-_EC2ContainerService-lunch-matching:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.148

ssh/datsu-mode.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.29

ssh/credit-or-cashing.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.112

ssh/pharmama.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.222

ssh/cardloan-farm.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.237

ssh/saimuseiri-blog.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.101

ssh/jikouenyou.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.183

ssh/xn--1cki9mlb6771a4yych82a30l.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.245

ssh/fx-cube.jp.strategy_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.52

ssh/pharmama.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.125

ssh/career-town.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.57

ssh/career-town.net.top_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.43

ssh/waterserver.info.lp.alg_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.250

ssh/kakuyasu-sumahogakuen.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.92

ssh/creditcard-seeker.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.49

ssh/machineslikeus.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.130

ssh/waterserver-mizu.com.ad_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.203

ssh/career-town.net.ads_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.40

ssh/now-cashing.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.79

ssh/tantei-media.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.141

ssh/fun-funx.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.114

ssh/xn--t8j6c6de2351bzzc5r8m.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.147

ssh/gakuchika.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.8

ssh/saimu-soudan-s.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.186

ssh/saimu-syakkin.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.129

ssh/gakuchika.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.85

ssh/saimu-syakkin0.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.79

ssh/ECS_Instance_-_EC2ContainerService-altalk:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.137

ssh/card-life.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.251

ssh/kakuyasu-sumahogakuen.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.154

ssh/creditcard-get.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.97

ssh/chawengvilla.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.128

ssh/randcins.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.86

ssh/randcins.jp_ec2_proxy_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.47

ssh/card-helper.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.87

ssh/fx-cube.jp.strategy_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.37

ssh/supple-life.com.blp-str_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.211

ssh/carbic-town.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.231

ssh/cosme-choice.com.microneedle_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.242

ssh/card-helper.net_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.214

ssh/cosme-choice.com.kakusan_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.107

ssh/carbic-town.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.129

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.212

ssh/waterserver-mizu.com.ad_ec2_dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.196

ssh/dxbase.diamond.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.28

ssh/genki-choice.com.aojiru_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.200

ssh/waterserver.asahi.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.188

ssh/saimu-simulation.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.165

ssh/ECS_Instance_-_EC2ContainerService-portal:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.42

ssh/wellslease_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.6

ssh/cba_ecs_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.137

ssh/career-town.net_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.121

ssh/cnt-fx-dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.113

ssh/ECS_Instance_-_EC2ContainerService-cba:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.128.161

ssh/now-cashing.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.191

ssh/ECS_Instance_-_EC2ContainerService-dev-cba:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.34

ssh/randcins.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.175

ssh/hop-job.com.pharmacist.lp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.136

ssh/hop-job.com.pharmacist.top_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.65

ssh/career-town.net.top_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.207

ssh/coinge.jp_ec2_dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.13

ssh/entrenet.jp.magazine_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.101

ssh/cue-ch.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.104

ssh/coinge.jp_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.65

ssh/card-life.jp_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.17

ssh/career-town.net.ads_ec2_dev:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.238

ssh/eikaiwa_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.222

ssh/syaxtukinnhennsai_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.120

ssh/cnt-wsm-web:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.106

ssh/shigyou_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.19

ssh/card-life.jp_ec2_stg01:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.4

ssh/xn--u8jvc1drbz972aywbk0by95ffo1aqm1c.com_ec2_stg:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.100.185

ssh/waterserver-mizu.com_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.216

ssh/cfm-test_ec2_prd:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.178

ssh/kadode-divorce.jp_ec2_prd_new:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.10.84

ssh/ECS_Instance_-_EC2ContainerService-stg-altalk:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.110.162

ssh/demo_1d:
	@ssh -i ~/.secret/ssh_id_rsa centos@10.0.12.125

