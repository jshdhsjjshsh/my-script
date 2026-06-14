-- NFT BATTLE v6  by TROTULOV39
local Pl=game.Players.LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local RunS=game:GetService("RunService")
local PG=Pl:WaitForChild("PlayerGui")
local Ev=RS:WaitForChild("Events",10)
if not Ev then warn("Events не найден!") return end

local Cases={"Daily","Trash","Beggar","Plodder","Office Clerk","Director","Oligarch","Manager","Frozen Heart","Bubble Gum","Cats","Dream","Glitch","Bloody Night","Ninja Turtles","Gold","Dark","Palm","Burj","Luxury","Monarch","Angel","M5 F90","G63","Porsche 911","URUS","Durov","Magnate","Cirque","REDO","Desk Calendars","Heavenfall","Divine","Photon Core","Sunny day","All In","Premium","Starter","Pepe10","Festive","Santa","Reindeer","XMAS Night","Last Chance","Frozen Heart"}
local SelCases,AutoOpen,Count,AutoSell,FavName={},false,10,false,""
local BattleCases,BattleOn,BattleCount={},false,10
local FuseCase,AutoFuseOn,FuseCount="",false,10
local TColors={Color3.fromRGB(150,30,255),Color3.fromRGB(30,255,100),Color3.fromRGB(255,150,30),Color3.fromRGB(30,100,255),Color3.fromRGB(255,50,50),Color3.fromRGB(0,220,220),Color3.fromRGB(255,200,0),Color3.fromRGB(255,0,150),Color3.fromRGB(0,150,255),Color3.fromRGB(100,255,255)}
local Theme=TColors[1]
local hue=0

-- UI HELPERS
local function C(r,g,b) return Color3.fromRGB(r,g,b) end
local function tw(o,g,t) TS:Create(o,TweenInfo.new(t or .13,Enum.EasingStyle.Quad),g):Play() end
local function rnd(o,r) local c=Instance.new("UICorner",o);c.CornerRadius=UDim.new(0,r or 8) end
local function str(o,c,t) local s=Instance.new("UIStroke",o);s.Color=c or Theme;s.Thickness=t or 1.5;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;return s end
local function fr(p,bg,sz,pos,r) local f=Instance.new("Frame",p);f.BackgroundColor3=bg or C(16,12,26);f.BorderSizePixel=0;f.Size=sz;f.Position=pos or UDim2.new(0,0,0,0);if r~=false then rnd(f,r or 8) end;return f end
local function lb(p,t,s,c,b,xa) local l=Instance.new("TextLabel",p);l.BackgroundTransparency=1;l.Text=t;l.TextSize=s or 11;l.TextColor3=c or C(220,210,255);l.Font=b and Enum.Font.GothamBold or Enum.Font.Gotham;l.TextXAlignment=xa or Enum.TextXAlignment.Left;l.Size=UDim2.new(1,0,1,0);return l end
local function btn(p,t,bg,fg,ts,pos,sz,r) local b=Instance.new("TextButton",p);b.BackgroundColor3=bg;b.TextColor3=fg or C(230,230,255);b.Font=Enum.Font.GothamBold;b.TextSize=ts or 10;b.Text=t;b.BorderSizePixel=0;b.AutoButtonColor=false;b.Size=sz or UDim2.new(1,0,0,22);b.Position=pos or UDim2.new(0,0,0,0);rnd(b,r or 7);return b end
local function tbox(p,ph,sz,pos) local t=Instance.new("TextBox",p);t.BackgroundColor3=C(24,18,38);t.BorderSizePixel=0;t.TextColor3=C(220,210,255);t.PlaceholderColor3=C(100,85,135);t.Font=Enum.Font.Gotham;t.TextSize=9;t.PlaceholderText=ph or "";t.Text="";t.ClearTextOnFocus=false;t.Size=sz or UDim2.new(1,0,0,22);t.Position=pos or UDim2.new(0,0,0,0);rnd(t,6);str(t,C(65,40,100));return t end
local function vib(b) local p=b.Position;local ox=p.X.Offset;task.spawn(function()for _=1,3 do tw(b,{Position=UDim2.new(p.X.Scale,ox+3,p.Y.Scale,p.Y.Offset)},.03);task.wait(.03);tw(b,{Position=UDim2.new(p.X.Scale,ox-3,p.Y.Scale,p.Y.Offset)},.03);task.wait(.03)end;tw(b,{Position=p},.03)end)end

-- GUI ROOT
local G=Instance.new("ScreenGui",PG);G.Name="NFT_v6";G.ResetOnSpawn=false;G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local M=fr(G,C(11,9,20),UDim2.new(0,210,0,330),UDim2.new(0.5,-105,0.5,-165),10)
local mStr=str(M,Theme,2)
local OS=M.Size

-- HEADER
local H2=fr(M,C(15,11,28),UDim2.new(1,0,0,38),UDim2.new(0,0,0,0),10)
fr(H2,C(15,11,28),UDim2.new(1,0,0,12),UDim2.new(0,0,1,-12),false)
local tl=lb(H2,"✦  NFT Battle v6",10,C(200,160,255),true);tl.Size=UDim2.new(1,-52,0,18);tl.Position=UDim2.new(0,8,0,4)
local balTxt=lb(H2,"",8,C(180,160,220));balTxt.Size=UDim2.new(1,-52,0,14);balTxt.Position=UDim2.new(0,8,0,22)
local minB=btn(H2,"−",C(25,18,45),C(200,180,255),13,UDim2.new(1,-48,0,8),UDim2.new(0,20,0,22),5)
local clsB=btn(H2,"✕",C(90,15,15),C(255,80,80),13,UDim2.new(1,-24,0,8),UDim2.new(0,20,0,22),5)
clsB.MouseButton1Click:Connect(function()vib(clsB);task.wait(.1);G:Destroy()end)

local function UpdBal()
 local s=Pl:FindFirstChild("_StarsValue");local t=Pl:FindFirstChild("_TONValue");local gm=Pl:FindFirstChild("_GemsValue")
 balTxt.Text="⭐"..(s and s.Value or 0).." 💠"..(t and t.Value or 0).." 💎"..(gm and gm.Value or 0)
end
UpdBal()
for _,n in ipairs({"_StarsValue","_TONValue","_GemsValue"})do local v=Pl:FindFirstChild(n);if v then v.Changed:Connect(UpdBal)end end

-- MINIMIZE
local body=fr(M,C(0,0,0),UDim2.new(1,0,1,-38),UDim2.new(0,0,0,38),false);body.BackgroundTransparency=1
local minimized=false
minB.MouseButton1Click:Connect(function()
 vib(minB);minimized=not minimized
 if minimized then body.Visible=false;tw(M,{Size=UDim2.new(0,210,0,38)},.18,Enum.EasingStyle.Back);minB.Text="+"
 else body.Visible=true;tw(M,{Size=OS},.18,Enum.EasingStyle.Back);minB.Text="−"end
end)

-- SIDEBAR TABS
local TB={"📦","⚔️","🔥","🔧","🎄","⚙️"}
local TF=fr(body,C(13,10,22),UDim2.new(0,24,1,0),UDim2.new(0,0,0,0),false)
local PG2=fr(body,C(16,12,26),UDim2.new(1,-24,1,0),UDim2.new(0,24,0,0),false)
local TP={}
for i,ic in ipairs(TB)do
 local b=btn(TF,ic,i==1 and Theme or C(20,15,32),C(240,240,255),11,UDim2.new(0,0,0,(i-1)*30),UDim2.new(1,0,0,28),0)
 local p=Instance.new("ScrollingFrame",PG2);p.Size=UDim2.new(1,-3,1,-3);p.Position=UDim2.new(0,2,0,2);p.BackgroundTransparency=1;p.Visible=i==1;p.CanvasSize=UDim2.new(0,0,0,0);p.ScrollBarThickness=2;p.ScrollBarImageColor3=Theme;TP[i]=p
 b.MouseButton1Click:Connect(function()
  vib(b)
  for j,pp in ipairs(TP)do pp.Visible=j==i end
  for _,bb in ipairs(TF:GetChildren())do if bb:IsA("TextButton")then tw(bb,{BackgroundColor3=C(20,15,32)})end end
  tw(b,{BackgroundColor3=Theme})
 end)
end
local P1,P2,P3,P4,P5,P6=TP[1],TP[2],TP[3],TP[4],TP[5],TP[6]

-- ══ P1: КЕЙСЫ ══
local y=0
-- Свой кейс
local cf0=fr(P1,C(22,16,36),UDim2.new(1,-2,0,22),UDim2.new(0,1,0,y),6)
local ci0=tbox(cf0,"+ Свой кейс...",UDim2.new(.72,0,1,-2),UDim2.new(0,1,0,1))
local ca0=btn(cf0,"ОК",Theme,C(240,240,255),8,UDim2.new(.73,1,0,1),UDim2.new(.27,-2,1,-2),5)
ca0.MouseButton1Click:Connect(function()
 local v=ci0.Text:match("^%s*(.-)%s*$")
 if v~=""then
  table.insert(Cases,v);ci0.Text=""
  local r=fr(P1,SelCases[v]and Theme or C(26,20,40),UDim2.new(1,-2,0,16),UDim2.new(0,1,0,y+10),5)
  local c=btn(r,v,C(0,0,0),C(220,210,255),8,UDim2.new(0,0,0,0),UDim2.new(1,0,1,0),0);c.BackgroundTransparency=1;c.TextXAlignment=Enum.TextXAlignment.Left
  c.MouseButton1Click:Connect(function()SelCases[v]=not SelCases[v];tw(r,{BackgroundColor3=SelCases[v]and Theme or C(26,20,40)})end)
  y=y+18;P1.CanvasSize=UDim2.new(0,0,0,y+80)
 end
end)
y=y+26
-- Разделитель
fr(P1,C(50,35,80),UDim2.new(1,0,0,1),UDim2.new(0,0,0,y),false);y=y+4
for _,n in ipairs(Cases)do
 local r=fr(P1,SelCases[n]and Theme or C(26,20,40),UDim2.new(1,-2,0,16),UDim2.new(0,1,0,y),5)
 local c=btn(r,n,C(0,0,0),C(220,210,255),8,UDim2.new(0,0,0,0),UDim2.new(1,0,1,0),0);c.BackgroundTransparency=1;c.TextXAlignment=Enum.TextXAlignment.Left
 c.MouseButton1Click:Connect(function()SelCases[n]=not SelCases[n];tw(r,{BackgroundColor3=SelCases[n]and Theme or C(26,20,40)})end)
 y=y+18
end
P1.CanvasSize=UDim2.new(0,0,0,y+80)
local cf=fr(P1,C(22,16,36),UDim2.new(1,0,0,16),UDim2.new(0,0,0,y),5)
local ci=tbox(cf,"кол-во",UDim2.new(0,30,1,-2),UDim2.new(0,2,0,1));ci.Text="10";ci.TextXAlignment=Enum.TextXAlignment.Center
ci.FocusLost:Connect(function()Count=tonumber(ci.Text)or 10;ci.Text=tostring(Count)end)
local cl2=lb(cf,"шт/раз",8,C(120,100,170));cl2.Size=UDim2.new(1,-36,1,0);cl2.Position=UDim2.new(0,34,0,0)
y=y+18
local ff=fr(P1,C(22,16,36),UDim2.new(1,0,0,16),UDim2.new(0,0,0,y),5)
local fi=tbox(ff,"NFT → ⭐ фаворит",UDim2.new(.68,0,1,0),UDim2.new(0,0,0,0))
local fb=btn(ff,"⭐",Theme,C(240,240,255),9,UDim2.new(.69,1,0,0),UDim2.new(.31,-1,1,0),5)
fb.MouseButton1Click:Connect(function()if fi.Text~=""then FavName=fi.Text;fi.Text=""end end)
y=y+18
local as=btn(P1,"🛒 Авто продажа: ВЫКЛ",C(35,20,50),C(220,210,255),8,UDim2.new(0,0,0,y),UDim2.new(1,0,0,18),5)
as.MouseButton1Click:Connect(function()vib(as);AutoSell=not AutoSell;as.Text="🛒 Авто продажа: "..(AutoSell and"ВКЛ"or"ВЫКЛ");tw(as,{BackgroundColor3=AutoSell and C(0,100,30) or C(35,20,50)})end)
y=y+20
local sb=btn(P1,"▶ СТАРТ",C(0,120,40),C(240,240,255),10,UDim2.new(0,0,0,y),UDim2.new(1,0,0,22),6)
str(sb,C(0,180,60),1.5)
sb.MouseButton1Click:Connect(function()
 vib(sb);AutoOpen=not AutoOpen;sb.Text=AutoOpen and"■ СТОП"or"▶ СТАРТ";tw(sb,{BackgroundColor3=AutoOpen and C(160,20,20)or C(0,120,40)})
 if AutoOpen then task.spawn(function()while AutoOpen do
  for cn,_ in pairs(SelCases)do if not AutoOpen then break end
   pcall(function()Ev.OpenCase:InvokeServer(cn,Count)end)
   if FavName~=""then for _,it in ipairs(Pl._Inventory:GetChildren())do if it.Name==FavName and not it:GetAttribute("Favorite")then task.wait(.05);pcall(function()Ev.Favorite:InvokeServer(it,true)end)end end end
   if AutoSell then Ev.Inventory:FireServer("Sell","ALL",false)end
   task.wait(.1)end end)end
end)
y=y+24;P1.CanvasSize=UDim2.new(0,0,0,y+4)

-- ══ P2: БАТЛЫ ══
local y2=0
for _,n in ipairs(Cases)do
 local r=fr(P2,BattleCases[n]and Theme or C(26,20,40),UDim2.new(1,-2,0,16),UDim2.new(0,1,0,y2),5)
 local c=btn(r,n,C(0,0,0),C(220,210,255),8,UDim2.new(0,0,0,0),UDim2.new(1,0,1,0),0);c.BackgroundTransparency=1;c.TextXAlignment=Enum.TextXAlignment.Left
 c.MouseButton1Click:Connect(function()local t=0;for _,_ in pairs(BattleCases)do t=t+1 end;if BattleCases[n]then BattleCases[n]=nil;tw(r,{BackgroundColor3=C(26,20,40)})elseif t<10 then BattleCases[n]=true;tw(r,{BackgroundColor3=Theme})end end)
 y2=y2+18
end
local bf=fr(P2,C(22,16,36),UDim2.new(1,0,0,16),UDim2.new(0,0,0,y2),5)
local bi=tbox(bf,"кол-во",UDim2.new(0,30,1,-2),UDim2.new(0,2,0,1));bi.Text="10";bi.TextXAlignment=Enum.TextXAlignment.Center
bi.FocusLost:Connect(function()BattleCount=tonumber(bi.Text)or 10;bi.Text=tostring(BattleCount)end)
lb(bf,"шт/батл",8,C(120,100,170)).Size=UDim2.new(1,-36,1,0);lb(bf,"шт/батл",8,C(120,100,170)).Position=UDim2.new(0,34,0,0)
y2=y2+18
-- NFT Battle Dump: батлы создаются через Events.Battles
local botBtn=btn(P2,"🤖 Бот: ВЫКЛ",C(35,20,50),C(220,210,255),8,UDim2.new(0,0,0,y2),UDim2.new(1,0,0,18),5)
local playWithBot=false
botBtn.MouseButton1Click:Connect(function()vib(botBtn);playWithBot=not playWithBot;botBtn.Text="🤖 Бот: "..(playWithBot and"ВКЛ"or"ВЫКЛ");tw(botBtn,{BackgroundColor3=playWithBot and C(80,35,160)or C(35,20,50)})end)
y2=y2+20
local bb=btn(P2,"⚔️ АВТО БАТЛЫ",C(160,60,0),C(240,240,255),10,UDim2.new(0,0,0,y2),UDim2.new(1,0,0,22),6)
str(bb,C(220,90,0),1.5)
bb.MouseButton1Click:Connect(function()
 vib(bb);BattleOn=not BattleOn;bb.Text=BattleOn and"■ СТОП"or"⚔️ АВТО БАТЛЫ";tw(bb,{BackgroundColor3=BattleOn and C(160,20,20)or C(160,60,0)})
 if BattleOn then task.spawn(function()while BattleOn do
  if playWithBot then pcall(function()Ev.Battles:InvokeServer("CallABot")end);task.wait(.5)end
  local bc={};for cn,_ in pairs(BattleCases)do for i=1,BattleCount do table.insert(bc,cn);if#bc>=10 then break end end;if#bc>=10 then break end end
  if#bc>0 then pcall(function()Ev.Battles:InvokeServer("Create",bc,{})end)end
  task.wait(30)end end)end
end)
y2=y2+24;P2.CanvasSize=UDim2.new(0,0,0,y2+4)

-- ══ P3: ФЬЮЗ ══
local fy=0
local fusLbl=lb(P3,"Выбран: —",8,C(160,130,220),true);fusLbl.Size=UDim2.new(1,0,0,14);fusLbl.Position=UDim2.new(0,2,0,fy);fy=fy+16
for _,n in ipairs(Cases)do
 local r=fr(P3,FuseCase==n and Theme or C(26,20,40),UDim2.new(1,-2,0,16),UDim2.new(0,1,0,fy),5)
 local c=btn(r,n,C(0,0,0),C(220,210,255),8,UDim2.new(0,0,0,0),UDim2.new(1,0,1,0),0);c.BackgroundTransparency=1;c.TextXAlignment=Enum.TextXAlignment.Left
 c.MouseButton1Click:Connect(function()FuseCase=FuseCase==n and""or n;fusLbl.Text="Выбран: "..(FuseCase==""and"—"or FuseCase);for _,ch in ipairs(P3:GetChildren())do if ch:IsA("Frame")then local bt=ch:FindFirstChildOfClass("TextButton");if bt then tw(ch,{BackgroundColor3=bt.Text==FuseCase and Theme or C(26,20,40)})end end end end)
 fy=fy+18
end
local fcf=fr(P3,C(22,16,36),UDim2.new(1,0,0,16),UDim2.new(0,0,0,fy),5)
local fci=tbox(fcf,"кол-во",UDim2.new(0,30,1,-2),UDim2.new(0,2,0,1));fci.Text="10";fci.TextXAlignment=Enum.TextXAlignment.Center
fci.FocusLost:Connect(function()FuseCount=tonumber(fci.Text)or 10;fci.Text=tostring(FuseCount)end)
fy=fy+20
local fusBtn=btn(P3,"🔥 АВТО ФЬЮЗ",C(110,25,190),C(240,240,255),10,UDim2.new(0,0,0,fy),UDim2.new(1,0,0,22),6)
str(fusBtn,C(160,50,240),1.5)
fusBtn.MouseButton1Click:Connect(function()
 vib(fusBtn);AutoFuseOn=not AutoFuseOn;fusBtn.Text=AutoFuseOn and"■ СТОП"or"🔥 АВТО ФЬЮЗ";tw(fusBtn,{BackgroundColor3=AutoFuseOn and C(160,20,20)or C(110,25,190)})
 if AutoFuseOn and FuseCase~=""then task.spawn(function()while AutoFuseOn do
  pcall(function()Ev.OpenCase:InvokeServer(FuseCase,FuseCount)end);task.wait(.3)
  local groups={};for _,it in ipairs(Pl._Inventory:GetChildren())do if not it:GetAttribute("Unique")and not it:GetAttribute("Favorite")then groups[it.Name]=groups[it.Name]or{};table.insert(groups[it.Name],it)end end
  for _,items in pairs(groups)do if#items>=5 then local five={items[1],items[2],items[3],items[4],items[5]};pcall(function()Ev.Fuse:InvokeServer("Fuse",five,true)end);break end end
  task.wait(1)end end)end
end)
fy=fy+24;P3.CanvasSize=UDim2.new(0,0,0,fy+4)

-- ══ P4: ЧИТЫ ══
local ly=0
local function AB(tx,cb)local b=btn(P4,tx,Theme,C(240,240,255),8,UDim2.new(0,0,0,ly),UDim2.new(1,0,0,18),5);b.MouseButton1Click:Connect(function()vib(b);cb()end);ly=ly+20 end
local function AI(tx,cb)local f=fr(P4,C(22,16,36),UDim2.new(1,0,0,18),UDim2.new(0,0,0,ly),5);local i=tbox(f,tx,UDim2.new(.68,0,1,0),UDim2.new(0,0,0,0));local o=btn(f,"OK",Theme,C(240,240,255),8,UDim2.new(.69,1,0,0),UDim2.new(.31,-1,1,0),5);o.MouseButton1Click:Connect(function()cb(i.Text);i.Text=""end);ly=ly+20 end
AB("💰 Вся валюта",function()for _,n in ipairs({"_StarsValue","_TONValue","_GemsValue","_SnowflakesValue"})do local v=Pl:FindFirstChild(n);if v then v.Value=999999999 end end end)
AI("Звёзды",function(t)local v=Pl:FindFirstChild("_StarsValue");if v then v.Value=tonumber(t)or v.Value end end)
AI("TON",function(t)local v=Pl:FindFirstChild("_TONValue");if v then v.Value=tonumber(t)or v.Value end end)
AI("Гемы",function(t)local v=Pl:FindFirstChild("_GemsValue");if v then v.Value=tonumber(t)or v.Value end end)
AB("⚡ Fast Upgrade",function()local p=Pl:FindFirstChild("_1628441770")or Instance.new("NumberValue",Pl);p.Name="_1628441770";p.Value=1 end)
AB("📊 Заполнить индекс",function()local idx=Pl:FindFirstChild("_Index");if idx then for _,v in ipairs(idx:GetChildren())do if v:IsA("IntValue")then v.Value=999999 end end end end)
AB("🔓 Все геймпасы",function()for _,id in ipairs({1628441770,1651738174,1640776898})do local p=Pl:FindFirstChild("_"..id)or Instance.new("NumberValue",Pl);p.Name="_"..id;p.Value=1 end end)
AI("NFT в инвентарь",function(t)Instance.new("StringValue",Pl._Inventory).Name=t end)
AI("Лучший дроп",function(t)local d=Pl:FindFirstChild("_BestDrop");if d then d.Value=t end end)
AI("NFT в индекс",function(t)local p=t:split(",");local idx=Pl:FindFirstChild("_Index");if idx then local v=idx:FindFirstChild(p[1]);if not v then v=Instance.new("IntValue",idx);v.Name=p[1]end;v.Value=v.Value+(tonumber(p[2])or 1)end end)
AB("🍀 Удача x2",function()local l=RS:FindFirstChild("LuckValue");if l then l.Value=600 end;local lp=Pl:FindFirstChild("_LuckyPotion");if lp then lp.Value=600 end end)
AB("🍀 Удача x4",function()local l=RS:FindFirstChild("LuckValue2");if l then l.Value=600 end;local lp=Pl:FindFirstChild("_LuckyPotion2");if lp then lp.Value=600 end end)
AB("✝️ Благословение",function()local c=RS:FindFirstChild("CrossValue");if c then c.Value=300 end end)
P4.CanvasSize=UDim2.new(0,0,0,ly+4)

-- ══ P5: НГ (как в в8, без накрутки снежинок) ══
local ny=0
-- Балансы НГ
local nbF=fr(P5,C(16,12,28),UDim2.new(1,0,0,26),UDim2.new(0,0,0,ny),6)
local snLbl=lb(nbF,"❄️0 снежинок",8,C(140,210,255),true);snLbl.Size=UDim2.new(.5,0,1,0);snLbl.Position=UDim2.new(0,4,0,0)
local spLbl=lb(nbF,"🎰0 спинов",8,C(255,200,80),true);spLbl.Size=UDim2.new(.5,0,1,0);spLbl.Position=UDim2.new(.5,0,0,0)
local function updNG()
 local sv=Pl:FindFirstChild("_SnowflakesValue");local cv=Pl:FindFirstChild("_ChristmasSpins")
 if sv then snLbl.Text="❄️"..sv.Value.." снег" end
 if cv then spLbl.Text="🎰"..cv.Value.." спин" end
end
updNG();task.spawn(function()while task.wait(1)do updNG()end end)
ny=ny+28
-- НГ СПИН кнопка — как в в8: крутит пока есть спины
local ngBtn=btn(P5,"🎡 НГ СПИН",C(160,25,25),C(255,220,100),10,UDim2.new(0,0,0,ny),UDim2.new(1,0,0,24),6)
str(ngBtn,C(220,60,60),1.5)
-- Это NFT Battle Dump: Events.Christmas:InvokeServer("Spin")
-- ngBtn работает как в в8 Events.Spin — тут Events.Christmas
ngBtn.MouseButton1Click:Connect(function()
 vib(ngBtn)
 task.spawn(function()
  local spinning=true
  ngBtn.Text="⏹ СТОП"
  tw(ngBtn,{BackgroundColor3=C(120,15,15)})
  -- Второе нажатие = стоп (переключатель через замену функции)
  local conn;conn=ngBtn.MouseButton1Click:Connect(function()spinning=false;conn:Disconnect()end)
  while spinning do
   local cv=Pl:FindFirstChild("_ChristmasSpins")
   if cv and cv.Value<=0 then break end
   pcall(function()Ev.Christmas:InvokeServer("Spin")end)
   updNG()
   task.wait(.3)
  end
  spinning=false;pcall(function()conn:Disconnect()end)
  tw(ngBtn,{BackgroundColor3=C(160,25,25)});ngBtn.Text="🎡 НГ СПИН"
 end)
end)
ny=ny+26
-- Снег и музыка
local snowBtn=btn(P5,"❄️ Снег: ВЫКЛ",C(28,22,42),C(220,210,255),8,UDim2.new(0,0,0,ny),UDim2.new(1,0,0,18),5)
snowBtn.MouseButton1Click:Connect(function()local sf=PG.MainGui.Pages.Home.MainFrame:FindFirstChild("Snowfall");if sf then sf.Enabled=not sf.Enabled;snowBtn.Text=sf.Enabled and"❄️ Снег: ВКЛ"or"❄️ Снег: ВЫКЛ";tw(snowBtn,{BackgroundColor3=sf.Enabled and C(0,100,150)or C(28,22,42)})end end)
ny=ny+20
local musicOn=false
local musicBtn=btn(P5,"🎵 Музыка: ВЫКЛ",C(28,22,42),C(220,210,255),8,UDim2.new(0,0,0,ny),UDim2.new(1,0,0,18),5)
musicBtn.MouseButton1Click:Connect(function()musicOn=not musicOn;musicBtn.Text="🎵 Музыка: "..(musicOn and"ВКЛ"or"ВЫКЛ");tw(musicBtn,{BackgroundColor3=musicOn and C(0,100,30)or C(28,22,42)})end)
ny=ny+20
-- НГ кейсы
local ngLabel=lb(P5,"── НГ КЕЙСЫ ──",8,C(100,80,145),true);ngLabel.Size=UDim2.new(1,0,0,12);ngLabel.Position=UDim2.new(0,0,0,ny);ngLabel.TextXAlignment=Enum.TextXAlignment.Center;ny=ny+14
for _,cn in ipairs({"Festive","Santa","Reindeer","XMAS Night"})do
 local b=btn(P5,"🎁 "..cn.."  [NFT Battle Dump]",C(100,18,18),C(220,210,255),8,UDim2.new(0,0,0,ny),UDim2.new(1,0,0,18),5)
 b.MouseButton1Click:Connect(function()vib(b);Ev.GUI:Fire("CasePage",cn)end);ny=ny+20
end
P5.CanvasSize=UDim2.new(0,0,0,ny+4)

-- ══ P6: НАСТРОЙКИ ══
local sy=0
local av=Instance.new("ImageLabel",P6);av.Size=UDim2.new(0,34,0,34);av.Position=UDim2.new(0,4,0,4);av.Image="https://www.roblox.com/headshot-thumbnail/image?userId=9988144824&width=150&height=150&format=png";av.BackgroundColor3=C(28,20,40);Instance.new("UICorner",av).CornerRadius=UDim.new(1,0);str(av,Theme)
local cl3=lb(P6,"TROTULOV39",9,C(220,210,255),true);cl3.Size=UDim2.new(1,-44,0,14);cl3.Position=UDim2.new(0,42,0,5)
local vl=lb(P6,"NFT Battle v6.0",7,C(130,110,175));vl.Size=UDim2.new(1,-44,0,12);vl.Position=UDim2.new(0,42,0,20)
sy=42
local thLbl=lb(P6,"Цвет темы:",8,C(140,120,190),true);thLbl.Size=UDim2.new(1,0,0,12);thLbl.Position=UDim2.new(0,2,0,sy);sy=sy+14
local colorRefs={}
for i=1,10 do
 local clr=TColors[i]
 local b=btn(P6,"",clr,C(240,240,255),8,UDim2.new((i-1)%5*.2,1,0,sy+math.floor((i-1)/5)*20),UDim2.new(.2,-2,0,18),5)
 table.insert(colorRefs,b)
 b.MouseButton1Click:Connect(function()
  Theme=clr
  mStr.Color=Theme
  for _,tb in ipairs(TF:GetChildren())do if tb:IsA("TextButton")and tb.BackgroundColor3~=C(20,15,32)then tw(tb,{BackgroundColor3=Theme})end end
  for _,cr in ipairs(colorRefs)do str(cr,cr.BackgroundColor3==Theme and C(255,255,255)or C(0,0,0),.5)end
 end)
end
sy=sy+44
P6.CanvasSize=UDim2.new(0,0,0,sy+4)

-- DRAG (шапка)
local drag,ds,sp=false,nil,nil
H2.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;ds=UIS:GetMouseLocation();sp=M.Position end end)
UIS.InputChanged:Connect(function(i)if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=UIS:GetMouseLocation()-ds;M.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)

-- РАДУГА
RunS.Heartbeat:Connect(function(dt)
 hue=(hue+dt*.2)%1
 local rc=Color3.fromHSV(hue,.85,1)
 mStr.Color=rc
end)

print("✅ NFT Battle v6 загружен!")
print("   НГ СПИН → Events.Christmas:InvokeServer('Spin') — крутит пока есть спины")
print("   НГ КЕЙСЫ → Events.GUI:Fire('CasePage', name) — NFT Battle Dump")
