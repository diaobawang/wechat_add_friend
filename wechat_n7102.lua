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
local COUNT_PER_TIME = 20 -- 一次添加多少人

-- 数据文件路径
path = "/mnt/sdcard/TouchSprite/lua/res3"
local logFile = io.open("/mnt/sdcard/TouchSprite/lua/log.txt", "r+");
local failFile = io.open("/mnt/sdcard/TouchSprite/lua/failed.txt", "a");

local file = io.open(path, "r");

local lastLineNumber = 0;
if logFile
then
    lastLineNumber = logFile:read("*n")
else
    logFile = io.open("/mnt/sdcard/TouchSprite/lua/log.txt", "w")
end

if not lastLineNumber
then
    lastLineNumber = 0;
end

principalWx = "coachT"
word = "您好，我是健身管家(coachT)的健身教练"

local addToContactButtonY
local failedCount = 0
local MAX_FAILED_COUNT = 3;


--   wechat button
conf = {
    ["add"] = { 685, 100 },
    ["add_friend"] = { 550, 300 },
    ["input"] = { 280, 250 },
    ["input_text"] = { 300, 100 },
    --["numpad"]={37,1079},
    ["search"] = { 360, 230},
    ["addToContact"] = { 170, 810 },
    ["clear"] = { 656, 310 },
    ["send"] = { 650, 120 },

    -- 没用到
    ["word"] = { 234, 255 },
    ["remark"] = { 450, 200 },
    ["remark2"] = { 450, 250 },
    ["clear_remark"] = { 607, 253 },
    ["back"] = { 58, 77 },
    ["save"] = { 387, 616 },
}


-- is_samecolor
function is_sameColor(r1, g1, b1, r2, g2, b2)
    return math.abs(r1 - r2) < 30 and math.abs(g1 - g2) < 30 and math.abs(b1 - b2) < 30
end

function isAddToContactButtonValid()
    -- y coordinate is variable
    local t1, t2 = conf["addToContact"][1], conf["addToContact"][2]
    local r, g, b = getColorRGB(conf["addToContact"][1], conf["addToContact"][2]);
    --toast("test"..t1..t2, 1)
    --mSleep(1000)
    --toast("rgb"..r..g..b, 1)
    --mSleep(1000)
    local result = is_sameColor(r, g, b, 70, 191, 24)
    local y
    if result
    then
        toast("same")
        addToContactButtonY = conf["addToContact"][2]
    else
        toast("not same")
        for i = 580, 860, 20
        do
            y = i;
            toast("not same" .. i, 0)
            r, g, b = getColorRGB(conf["addToContact"][1], y);
            result = is_sameColor(r, g, b, 70, 191, 24)
            if result
            then
                addToContactButtonY = y;
                break
            end
        end
    end
    return result
end

-- post request
-- post request

function sendRequest(tel, status)
    local sz = require("sz")
    local json = sz.json
    local http = require("szocket.http")
    local response_body = {}

    local post_data = 'tel=' .. tel .. "&status=" .. status .. "&wxname=" .. principalWx .. "&"

    res, code = http.request {
        url = "http://yy.wanmeikouqiang.com/dentistMaintin/modDentistMaintinByLua",
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


-- searchSuccess
function searchSuccess()
    --    snapshot("addBtn.png", 69, 564, 69+20, 564+20)
    --    local x, y = findImageInRegionFuzzy("addBtn.png", 60, 0, 293, 640, 1136, 0xffffff);
    -- local x, y = findAddBtn()

    -- if x ~= -1 then
    --     conf["addToContact"][1] = x
    --     conf["addToContact"][2] = y
    --     return true
    -- end

    -- return false

    return isAddToContactButtonValid()
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
    x, y = conf[key][1], conf[key][2]
    touchDU(x, y)
end



local currentLine = 1; -- start from 1
for l in file:lines() do

    toast(currentLine.."   "..l)
    local tel = l
    if currentLine > lastLineNumber
    then
        currentLine = currentLine + 1;
        logFile:seek("set", 0)
        logFile:write(currentLine)
        logFile:flush()
        print(l)

        current_time = os.date("%Y-%m-%d", os.time());
        wLog("wechat.log", current_time .. " begin:  " .. tel .. " " .. remark)

        -- close wechat
        closeApp("com.tencent.mm")
        mSleep(2000)
        -- run wechat
        runApp("com.tencent.mm")
        mSleep(10000)


        -- click tab2
        -- touchButtonForKey("tab2")

        -- click add
        touchButtonForKey("add")

        -- click input
        touchButtonForKey("add_friend")

        -- input
        touchButtonForKey("input")
        touchButtonForKey("input_text")

        inputText(tel)

        --touchButtonForKey("input_text")
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
            -- local addx, addy = findAddBtn()
            -- touchDU(addx, addy)

            --touchButtonForKey("addToContact")
            touchDU(conf["addToContact"][1], addToContactButtonY)
            mSleep(2000)


            -- input word
            touchButtonForKey("clear")
            -- touchButtonForKey("word")
            inputText(word)


            touchButtonForKey("send")
            -- sendRequest(tel,1)
            failedCount = 0
        else
            current_time = os.date("%Y-%m-%d", os.time());
            wLog("wechat_fail.log", current_time .. "  " .. tel .. " " .. remark)
            -- 记一条日志
            -- sendRequest(tel,2)
            --touchDU(400, 1000)

            failFile:write(l.."\n")
            failFile:flush()
            failedCount = failedCount + 1
            if failedCount >= MAX_FAILED_COUNT
            then
                mSleep(5 * 60 * 1000)
                failedCount = 0
            end
        end


        mSleep(1200)
        closeApp("com.tencent.mm")
        mSleep(30 * 1000)

        if ((currentLine  - lastLineNumber) % COUNT_PER_TIME == 0)
        then
            mSleep(10 * 60 * 1000)
        end

    else
        currentLine = currentLine + 1;
    end
end
file:close();
logFile:close();
failFile:close();


closeLog("wechat.log")
closeLog("wechat_fail.log")

