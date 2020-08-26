$Credential = Get-Credential

$WebRequestArgs = @{
  URI = "http://10.10.10.91/login/?next=/tightvnc/"
  SessionVariable = "MySession"
}

$request = Invoke-WebRequest @WebRequestArgs
$form = $request.Forms[0]
$form.fields['username']=$Credential.UserName
$form.fields['password']=$Credential.Password

$WebRequestArgsLogin = @{
  URI = 'http://10.10.10.91/login/?next=/tightvnc/' + $form.action
  WebSession = $MySession
  Method = "POST"
  Body = $form.Fields
}


$r = Invoke-WebRequest $WebRequestArgsLogin



#(gcm Invoke-WebRequest).ParameterSets[0] |select -ExpandProperty parameters |Out-GridView

$c = $host.UI.PromptForCredential('Your Credentials', 'Enter Credentials', '', '')
$r = Invoke-WebRequest 'http://1.2.3.4/' -SessionVariable my_session
$form = $r.Forms[0]
$form.fields['username'] = $c.UserName
$form.fields['password'] = $c.GetNetworkCredential().Password
$r = Invoke-WebRequest -Uri ('http://1.2.3.4' + $form.Action) -WebSession $my_session -Method POST -Body $form.Fields