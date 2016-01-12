用screen -dmS session name来建立一个处于断开模式下的会话（并指定其会话名）。
用screen -list 来列出所有会话。
用screen -r session name来重新连接指定会话。
用快捷键CTRL-a d 来暂时断开当前会话。
用法总结：
  打开一个新的screen，命令为 screen #一般只开一个。可以想象成上网一般只用开一个浏览器。
  打开现有的screen，命令为 screen -r #有时候多开了几个screen，用此命令即可查看开了哪些，而不会进入某个screen。
  screen -r 某个screen的编号 #将该screen retach，即进入这个screen。
  有时候运行上面的命令会提示这个screen已经在running了。为了将之在终端上显示出来，可用screen -dr screen编号 这个命令，先detach再retach。

  进入screen后，常用命令：
  ctrl+A；shift+“ #查看现有的bash（可理解为标签页），点击enter进入
  ctrl+A；ctrl+C #新建一个bash
  crtl+A+数字[0-9] #直接跳到第n个bash
  ctrl+A+A #bash之间快速切换
  ctrl+A+D #将screen detach（退出screen）
  ctrl+D #关闭当前bash，如果当前bash是screen的最后一个bash，则关闭screen
  ctrl+A；shift+k #关闭当前bash

  建议登陆服务器后，首先开启screen（开一个即可），然后新建bash，最多可建10个。每一个bash都可以单独浏览和工作。退出时一般用screen+A+D的命令，下一次登陆后用screen -r进入，此时可恢复上一次关闭时所有bash的状态。退出screen，关闭终端后，后台运行的程序不会终止。
