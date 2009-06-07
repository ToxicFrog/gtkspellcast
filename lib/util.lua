function string.trim(s)
    return s:gsub('^%s+', ''):gsub('%s+$','')
end


