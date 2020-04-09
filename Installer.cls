Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}src"/>
  <Default Name="Namespace" Value="IRISAPP"/>
  <Default Name="app" Value="irisapp" />
  
  <Default Name="cspappname" Value="jsonfilter" />
  <Default Name="cspappurl" Value="/csp/${cspappname}" />
  <Default Name="restappurl" Value="/csp/${cspappname}rest" />
  
  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="0">

    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
    <CSPApplication Url="${restappurl}" Directory="${cspdir}${cspappname}rest" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32" DispatchClass="Isc.JSONFiltering.Rest.FilteringDemo"/>
    <CSPApplication Url="${cspappurl}" Directory="${cspdir}${cspappname}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"/>
  </Namespace>

  <Invoke Class="App.Installer" Method="fixDispatchClass">
    <Arg Value="${restappurl}"/>
  </Invoke>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod fixDispatchClass(restApp As %String) As %Status
{
    Set ns = $Namespace
    Zn "%SYS"
    Do ##class(Security.Applications).Get(restApp,.p)
    Set p("DispatchClass")="Isc.JSONFiltering.Rest.FilteringDemo"
    Do ##class(Security.Applications).Modify(restApp,.p)
    zn ns
    Return $$$OK
}

}
