# ARG IMAGE=store/intersystems/irishealth:2019.3.0.308.0-community
# ARG IMAGE=store/intersystems/iris-community:2019.3.0.309.0
# ARG IMAGE=store/intersystems/iris-community:2019.4.0.379.0
# ARG IMAGE=store/intersystems/iris-community:2020.1.0.199.0
# ARG IMAGE=intersystemsdc/iris-community:2019.4.0.383.0-zpm
# ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
# ARG IMAGE=intersystems/irishealth:2019.4.0.383.0
ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
COPY irissession.sh /
RUN chmod +x /irissession.sh 

USER irisowner

COPY  Installer.cls .
COPY  src src
COPY  tests tests
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).setup() \
  zn "%SYS" \
  write "Create web application ..." \
  set webName = "/crud" \
  set webProperties("DispatchClass") = "Sample.PersonREST" \
  set webProperties("NameSpace") = "IRISAPP" \
  set webProperties("Enabled") = 1 \
  set webProperties("AutheEnabled") = 32 \
  set sc = ##class(Security.Applications).Create(webName, .webProperties) \
  write sc \
  write "Web application "_webName_" has been created!" \
  zn "IRISAPP" \
  zpm "install swagger-ui"
# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
