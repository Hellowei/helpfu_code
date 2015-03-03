-----屏蔽敏感词接口@vinYin 2014-11-3 ------------------------------------------------------------------------------------------------------------------
local senstive = require("local_config.Senstive");----加载世界上最脏的东西
function funcs.filterSenstive(inputStr,donotFilter,useMeToPlace)
    local useMeToReplace = useMeToPlace or "*"
    local result = inputStr;
  
    if donotFilter then---不需要过滤
        return result;
    else------------------开启过滤算法
        for k,v in pairs(senstive) do
            result,n = string.gsub(result,v,useMeToReplace)
        end
    end
    return result;
end
---------------------传入1970-01-01 8am 到现在的秒数，转为"%Y-%m-%d %H:%M:%S" 如12秒返回1970-01-01 08:00:12@vinyin
---------------------小知识：1970-01-01是uinx诞生时间，北京位于东八区，北京时间8am即格林威治0点整，
function funcs.getDateBysecond(seconds, dateformat)
    local temp = dateformat or "%Y-%m-%d %H:%M:%S";
    return os.date(temp, seconds)
end
---------------------根据基姆拉尔森公式计算服务器属于星期几 @vinyin-----------------------
function funcs.getDaythBySecond(seconds)
    local date  = funcs.getDateBysecond(seconds);
    local year  = tonumber(string.sub(date,1,4));
    local month = tonumber(string.sub(date,6,7));
    local day   = tonumber(string.sub(date,9,10));

    local dayth = funcs.getDaythByYMD(year,month,day);
    return dayth;
end
---------------------根据基姆拉尔森公式计算yyyy-mm--dd属于星期几 @vinyin-----------------------
--{"1表示星期天","2是星期一","3是星期二","4是星期三","5是星期四","6是星期五","7是星期六"};
function funcs.getDaythByYMD(year,month,day)
    local y,m,d = year,month,day;
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if    m < 3 then--------- 一月，二月当上成上一年的13 14月处理
          y = y - 1;
    end
    local w = y + math.floor(y/4) - math.floor(y/100) +  math.floor(y/400) + t[m] + d;
    return math.mod(w,7) + 1;
end
--second格式化转换 如1800得到 00：30：00
function funcs.getHourMinSec(inputSec)
    inputSec = math.ceil(inputSec);
    local temp = inputSec/3600;
    local h = temp - temp%1;
    inputSec = inputSec - h*3600;
    temp = inputSec/60;
    local min = temp - temp%1;
    inputSec = inputSec - min*60;
    local hourMinSec = nil;
    if h > 9 then
        hourMinSec = h;
    else
        hourMinSec = "0"..h;
    end
    
    if min > 9 then
        hourMinSec = hourMinSec..":"..min;
    else
        hourMinSec = hourMinSec..":0"..min;
    end
    if inputSec > 9 then
        hourMinSec = hourMinSec..":"..inputSec;
    else
        hourMinSec = hourMinSec..":0"..inputSec;
    end

    return hourMinSec;
end
------------------------拆分格式"53301_3|53306_1"字符串，得到数字 53301 3 53306 1---------------@vinyin~2014-9-18
function    funcs.getStuffAndNum(str)
    local pattern  = "|";
    local pattern1 = "_";
    local divi     = string.find(str,pattern);

    local str1     = string.sub(str,1,divi-1);
    local str2     = string.sub(str,divi+1);

    local divi1    = string.find(str1,pattern1);
    local stuff1   = tonumber(string.sub(str1,1,divi1-1));
    local num1     = tonumber(string.sub(str1,divi1+1));

    divi1          = string.find(str2,pattern1);
    local stuff2   = tonumber(string.sub(str2,1,divi1-1));
    local num2     = tonumber(string.sub(str2,divi1+1));
    return stuff1,num1,stuff2,num2;
end
--------------------------------
-- 计算 UTF8 字符串的长度，每一个中文算一个字符
-- @function [parent=#string] utf8len
-- @param string input 输入字符串
-- @return integer#integer  长度

--[[--

计算 UTF8 字符串的长度，每一个中文算一个字符

~~~ lua

local input = "你好World"
print(string.utf8len(input))
-- 输出 7

~~~

]]

-- end --

function string.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

-- start --

--------------------------------
-- 将数值格式化为包含千分位分隔符的字符串
-- @function [parent=#string] formatnumberthousands
-- @param number num 数值
-- @return string#string  格式化结果

--[[--

将数值格式化为包含千分位分隔符的字符串

~~~ lua

print(string.formatnumberthousands(1924235))
-- 输出 1,924,235

~~~

]]

-- end --

function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end