Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}src"/>
  <Default Name="Namespace" Value="IRISAPP"/>
  <Default Name="app" Value="irisapp" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="0">

    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
    <CSPApplication Url="/csp/${app}rest" Directory="${cspdir}${app}rest" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32" DispatchClass="Isc.JSONFiltering.Rest.FilteringDemo"/>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"/>
  </Namespace>

  <Namespace Name="${Namespace}">
    <Invoke Class="Isc.JSONFiltering.Test.FilteringTest" Method="SetUnitTestRoot">
      <Arg Value="/irisdev/app/src/cls/Isc/JSONFiltering/Test/"/>
    </Invoke>
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod fixDispatchClass() As %Status
{
    Set ns = $Namespace
    Zn "%SYS"
    Do ##class(Security.Applications).Get("/csp/irisapprest",.p)
    Set p("DispatchClass")="Isc.JSONFiltering.Rest.FilteringDemo"
    Do ##class(Security.Applications).Modify("/csp/irisapprest",.p)
    zn ns
    Return $$$OK
}

}