--
-- Created by IntelliJ IDEA.
-- User: xiaoyuan
-- Date: 7/16/15
-- Time: 1:55 PM
-- To change this template use File | Settings | File Templates.
--


init("0", 0);
initLog("wechat.log", 0)
initLog("wechat_fail.log", 0)

-- tels={"15930085252","18121441052","18500038061","13910714055","15765341912","15214661842","15000616178","13648618030","13845110756",}


-- remarks={"东小明","郑帅","王达","卢俊伟","杨艳飞","刘洋","韦梦瑶","李杰","牟建宇",}

remark = "coachT-学员"

-- 数据文件路径
path = "/User/Media/TouchSprite/lua/res2"

local file = io.open(path,"r");


principalWx="coachT"
word = "您好，我是健身管家(coachT)客服"


--   wechat button
conf={
    ["tab2"]={231, 1067},
    ["add"]={584, 85},
    ["input"]={146, 199},
    ["numpad"]={37,1079},
    ["search"]={536, 1088},

    ["addToContact"]={134,475},

    ["clear"] = {582,247},
    ["send"]={584, 85},

    ["word"]={234,255},

    ["remark"]={450, 200},

    ["remark2"]={450, 250},
    ["clear_remark"]={607, 253},

    ["back"]={58,77},
    ["save"]={387,616},
}

confPad = {
   ["tab2"]={669, 2004},
    ["add"]={357, 270},
    ["input"]={306, 168},
    ["numpad"]={48,1989},
    ["search"]={1398, 1725},

    ["addToContact"]={134,475},

    ["clear"] = {1476,252},
    ["send"]={1485, 85},

    ["word"]={234,255},

    ["remark"]={450, 200},

    ["remark2"]={450, 250},
    ["clear_remark"]={607, 253},

    ["back"]={58,77},
    ["save"]={387,616},

}


-- is_samecolor
function is_sameColor(r1, g1, b1, r2, g2, b2)
    return math.abs(r1 - r2) < 30 and math.abs(g1 - g2) < 30 and math.abs(b1 - b2) < 30
end

function findAddBtn()
    local tempx;
    local tempy;
    if screenSizeIsPad()
    then 
        tempx = 114;
        tempy = 717;
    else 
        tempx = 559;
        tempy = 153;
    end

    local nowx, nowy = tempx, tempy
    for i = 1, 26, 1 do
        local realR, realG, realB = getColorRGB(nowx, nowy)
        if is_sameColor(realR, realG, realB, 6, 191, 4) == true then
            return nowx, nowy
        end
        nowy = nowy + (i * 60)
        -- mSleep(500)
    end

    mSleep(500)
    return -1, -1
end


-- post request
-- post request

function sendRequest(tel,status)
    local sz = require("sz")
    local json = sz.json
    local http = require("szocket.http")
    local response_body = {}
  
    local post_data = 'tel='..tel.."&status="..status.."&wxname="..principalWx.."&"

    res, code = http.request{  
        url =  "http://yy.wanmeikouqiang.com/dentistMaintin/modDentistMaintinByLua",  
        method = "POST",  
        headers =   
        {  
            ["Content-Type"] = "application/x-www-form-urlencoded",  
            ["content-length"] = string.len(post_data)
        },  
        source = ltn12.source.string(post_data),  
        sink = ltn12.sink.table(response_body)  
    } 


end

--设备分辨率
function screenSizeIsPad()
local width, height = getScreenSize();
    if width == 1536 and height == 2048 then
        return true;       
     else
        return false;
    end
        return false;
end




-- searchSuccess
function searchSuccess()
--    snapshot("addBtn.png", 69, 564, 69+20, 564+20)
--    local x, y = findImageInRegionFuzzy("addBtn.png", 60, 0, 293, 640, 1136, 0xffffff);
    local x, y = findAddBtn()

    if x ~= -1 then
        conf["addToContact"][1] = x
        conf["addToContact"][2] = y
        return true
    end

    return false
end


-- touchDU
function touchDU(x, y)
    mSleep(1000)
    touchDown(1, x, y)
    mSleep(50)
    touchUp(1, x, y)
    mSleep(2000)
end


-- touch button for key
function touchButtonForKey(key)
    local x, y
    if screenSizeIsPad() 
    then 
        x, y = conf[key][1], conf[key][2] 
    else 
        x, y = confPad[key][1], confPad[key][2] 
    end
    touchDU(x, y)
end



for l in file:lines() do

    local tel = l

    current_time = os.date("%Y-%m-%d", os.time());
    wLog("wechat.log", current_time .. " begin:  " .. tel .. " " .. remark)

    -- close wechat
    closeApp("com.tencent.xin")
    mSleep(2000)
    -- run wechat
    runApp("com.tencent.xin")
    mSleep(8000)


    -- click tab2
    touchButtonForKey("tab2")

    -- click add
    touchButtonForKey("add")

    -- click input
    touchButtonForKey("input")

    -- input
    inputText(tel)
    touchButtonForKey("numpad")


    -- search
    touchButtonForKey("search")
    mSleep(5000)

    if searchSuccess() then

        -- modify remark
       -- touchButtonForKey("add")

        --touchButtonForKey("remark")

        --touchButtonForKey("remark2")
        --mSleep(1000)
        --touchButtonForKey("clear_remark")

        --inputText(remark)


        --touchButtonForKey("add")

        --touchButtonForKey("save")


        --touchButtonForKey("back")


--        wLog("wechat.log", conf["addToContact"][1] .. " " .. conf["addToContact"][2])
        -- click addToContact
--        touchButtonForKey("addToContact")
        local addx, addy = findAddBtn()
        touchDU(addx, addy)
        mSleep(2000)


        -- input word
        touchButtonForKey("clear")
        touchButtonForKey("word")
        inputText(word)


        touchButtonForKey("send")
        sendRequest(tel,1)
    else
        current_time = os.date("%Y-%m-%d", os.time());
        wLog("wechat_fail.log", current_time .. "  " .. tel .. " " .. remark)
        -- 记一条日志
        sendRequest(tel,2)
    end


    mSleep(1200)
    closeApp("com.tencent.xin")
    mSleep(1000)

end


closeLog("wechat.log")
closeLog("wechat_fail.log")

