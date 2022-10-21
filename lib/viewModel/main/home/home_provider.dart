import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/model/network_model/server_list_model.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class HomeProvider extends ChangeNotifier {
  double rating = 0.0;
  Uint8List? image;
  bool isLoading = false;
  bool isConnected = false;
  bool isHoverCity = false;
  bool isHoverPowerButton = false;

  bool openServerView = false;

  void updateNavigator(bool value) {
    openServerView = value;
    notifyListeners();
  }

  void updateHoverCityOrPowerButton(bool isHovered, bool isCity) {
    if (isCity) {
      isHoverCity = isHovered;
    } else {
      isHoverPowerButton = isHovered;
    }
    notifyListeners();
  }

  void updateRating(double value) {
    rating = value;
    notifyListeners();
  }

  Future<void> onPressPower() async {
    isLoading = true;
    notifyListeners();

    String request =
        !isConnected ? "rasdial aaaaa" : "rasdial aaaaa /disconnect";

    final result = await Process.run('powershell.exe', [request]);

    if (result.exitCode == 0) {
      isConnected = !isConnected;
    } else {
      isConnected = false;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> getPathTemp() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future<void> connection(ServerItem server, String emailPassword) async {
    isLoading = true;
    notifyListeners();
    final checkConnectionStatus =
        await writePowerShell("Get-VpnConnection NoLogin");
    Logger().i(checkConnectionStatus.toString());
    const splitter = LineSplitter();
    final sampleTextLines = splitter.convert(checkConnectionStatus.stdout);
    for (var i = 0; i < sampleTextLines.length; i++) {
      if (i == 12) {
        String status = sampleTextLines[i].split(":").last.trim();
        if (status[0] == "C") {
          await writePowerShell("rasdial NoLogin /d");
          isConnected = false;
          isLoading = false;
          notifyListeners();
          return;
        }
        break;
      }
    }
    String tempPath = await getPathTemp();
    final fileCertificate = File("$tempPath/vpnCertificate.cer");
    try {
      await fileCertificate.create();
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
    await writeCertificate(fileCertificate, server.certificateFile);
    String lineImportCertificate =
        "Import-Certificate -FilePath ${fileCertificate.path} -CertStoreLocation cert:\\LocalMachine\\Root";
    final resultShell = await writePowerShell(lineImportCertificate);
    if (resultShell.exitCode == 0) {
      await fileCertificate.delete();
    } else {
      isLoading = false;
      notifyListeners();
      return;
    }
    Logger().i(tempPath.toString());
    final fileVpnPbk = File("$tempPath/vpn.pbk");
    final findPbk = await fileVpnPbk.exists();
    if (findPbk) {
      await fileVpnPbk.delete();
    }
    await fileVpnPbk.create();
    await writePbkFile(fileVpnPbk, server.address);
    String lineConnection = "rasdial NoLogin $emailPassword $emailPassword";
    final resultShell2 = await writePowerShell(lineConnection);
    if (resultShell2.exitCode == 0) {
      Logger().i("Success");
      isConnected = true;
      notifyListeners();
    } else {
      Logger().e("Fail");
      "Fail".showCustomToast();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> writePbkFile(File fileVpnPbk, String ipAddress) async {
    try {
      String pbkText = """
                  [NoLogin] 
Encoding=1 
PBVersion=8 
Type=2 
AutoLogon=0 
UseRasCredentials=1 
LowDateTime=-1399549488 
HighDateTime=30982477 
DialParamsUID=14194781 
Guid=06CD0EFEF1DF66468DCB56EFE252881B 
VpnStrategy=8 
ExcludedProtocols=0 
LcpExtensions=1 
DataEncryption=8 
SwCompression=0 
NegotiateMultilinkAlways=0 
SkipDoubleDialDialog=0 
DialMode=0 
OverridePref=15 
RedialAttempts=3 
RedialSeconds=60 
IdleDisconnectSeconds=0 
RedialOnLinkFailure=1 
CallbackMode=0 
CustomDialDll= 
CustomDialFunc= 
CustomRasDialDll= 
ForceSecureCompartment=0 
DisableIKENameEkuCheck=0 
AuthenticateServer=0 
ShareMsFilePrint=1 
BindMsNetClient=1 
SharedPhoneNumbers=0 
GlobalDeviceSettings=0 
PrerequisiteEntry= 
PrerequisitePbk= 
PreferredPort=VPN2-0 
PreferredDevice=WAN Miniport (IKEv2) 
PreferredBps=0 
PreferredHwFlow=0 
PreferredProtocol=0 
PreferredCompression=0 
PreferredSpeaker=0 
PreferredMdmProtocol=0 
PreviewUserPw=1 
PreviewDomain=1 
PreviewPhoneNumber=0 
ShowDialingProgress=1 
ShowMonitorIconInTaskBar=0 
CustomAuthKey=26 
AuthRestrictions=128 
IpPrioritizeRemote=1 
IpInterfaceMetric=0 
IpHeaderCompression=0 
IpAddress=0.0.0.0 
IpDnsAddress=0.0.0.0 
IpDns2Address=0.0.0.0 
IpWinsAddress=0.0.0.0 
IpWins2Address=0.0.0.0 
IpAssign=1 
IpNameAssign=1 
IpDnsFlags=0 
IpNBTFlags=1 
TcpWindowSize=0 
UseFlags=2 
IpSecFlags=0 
IpDnsSuffix= 
Ipv6Assign=1 
Ipv6Address=:: 
Ipv6PrefixLength=0 
Ipv6PrioritizeRemote=1 
Ipv6InterfaceMetric=0 
Ipv6NameAssign=1 
Ipv6DnsAddress=:: 
Ipv6Dns2Address=:: 
Ipv6Prefix=0000000000000000 
Ipv6InterfaceId=0000000000000000 
DisableClassBasedDefaultRoute=0 
DisableMobility=0 
NetworkOutageTime=0 
IDI= 
IDR= 
ImsConfig=0 
IdiType=0 
IdrType=0 
ProvisionType=0 
PreSharedKey= 
CacheCredentials=1 
NumCustomPolicy=0 
NumEku=0 
UseMachineRootCert=0 
Disable_IKEv2_Fragmentation=0 
PlumbIKEv2TSAsRoutes=0 
NumServers=0 
RouteVersion=1 
NumRoutes=0 
NumNrptRules=0 
AutoTiggerCapable=0 
NumAppIds=0 
NumClassicAppIds=0 
SecurityDescriptor= 
ApnInfoProviderId= 
ApnInfoUsername= 
ApnInfoPassword= 
ApnInfoAccessPoint= 
ApnInfoAuthentication=1 
ApnInfoCompression=0 
DeviceComplianceEnabled=0 
DeviceComplianceSsoEnabled=0 
DeviceComplianceSsoEku= 
DeviceComplianceSsoIssuer= 
FlagsSet=0 
Options=0 
DisableDefaultDnsSuffixes=0 
NumTrustedNetworks=0 
NumDnsSearchSuffixes=0 
PowershellCreatedProfile=0 
ProxyFlags=0 
ProxySettingsModified=0 
ProvisioningAuthority= 
AuthTypeOTP=0 
GREKeyDefined=0 
NumPerAppTrafficFilters=0 
AlwaysOnCapable=0 
DeviceTunnel=0 
PrivateNetwork=0 
ManagementApp= 
 
NETCOMPONENTS= 
ms_msclient=1 
ms_server=1 
 
MEDIA=rastapi 
Port=VPN2-0 
Device=WAN Miniport (IKEv2) 
 
DEVICE=vpn 
PhoneNumber=$ipAddress 
AreaCode= 
CountryCode=0 
CountryID=0 
UseDialingRules=0 
Comment= 
FriendlyName= 
LastSelectedPhone=0 
PromoteAlternates=0 
TryNextAlternateOnFail=1
                  """;
      await fileVpnPbk.writeAsString(pbkText);
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }

  Future<void> writeCertificate(
      File fileCertificate, String certificateFile) async {
    try {
      String text = await fileCertificate.readAsString();
      if (text.isEmpty) {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String decoded = stringToBase64.decode(certificateFile);
        await fileCertificate.writeAsString(decoded);
      } else {}
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }

  Future<ProcessResult> writePowerShell(String line) async {
    return await Process.run('powershell.exe', [line]);
  }
}
