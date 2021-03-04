#!/usr/bin/bash
export jmx_template="orderservice"
export suffix=".jmx"
export jmx_template_filename="${jmx_template}${suffix}"
export os_type=`uname`

echo "自动化压测脚本全部开始"

thread_number_array=(10)
for num in "${thread_number_array[@]}"
do
  #生成对应的压测线程的jmx文件
  export jmx_filename="${jmx_template_filename}_${num}${suffix}"
  export jtl_filename="test_${num}.jtl"
  export web_report_name="web_${num}"
  rm -f ${jmx_filename} ${jtl_filename}
  rm -rf ${web_report_name}
  cp ${jmx_template_filename} $jmx_filename
  echo "生成jmx压测脚本"
  if [[ "${os_type}" == "Darwin" ]]; then
      sed -i "" "s/thread_num/${num}/g" ${jmx_filename}
  else
      sed -i "s/thread_num/${num}/g" ${jmx_filename}
  fi
  #jemter 静默压测
  ${JMETER_HOME}/bin/jmeter -n -t ${jmx_filename} -l ${jtl_filename}
  #生成web压测报告
  ${JMETER_HOME}/bin/jmeter -g ${jtl_filename} -e -o ${web_report_name}
done
echo "压测结束"