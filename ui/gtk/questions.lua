local gtk = require "lgui"
local grid = ui.win.Questions

local questions = {}
local shrinkfill = gtk.SHRINK + gtk.FILL
local expandfill = gtk.EXPAND + gtk.FILL

function ui.add_question(q)
    local label = gtk.Label.new(q.question)
    local answers = gtk.ComboBox.newText()
    local sep = gtk.HSeparator.new()
    
    for _,answer in ipairs(q.answers) do
        answers:appendText(answer)
    end
    
    questions[#questions+1] = { label = label, answers = answers, sep = sep }
    grid:resize(#questions+1, 3)
    grid:attach(label, 0, 1, #questions, #questions+1, shrinkfill, shrinkfill, 0, 0)
    grid:attach(sep, 1, 2, #questions, #questions+1, expandfill, expandfill, 5, 0)
    grid:attach(answers, 2, 3, #questions, #questions+1, shrinkfill, shrinkfill, 0, 0)
    
    answers:set("active", 0)
end

function ui.show_questions()
    grid:showAll()
end

function ui.hide_questions()
    grid:hideAll()
end

function ui.clear_questions()
    for _,q in ipairs(questions) do
        grid:remove(q.label)
        grid:remove(q.answers)
        grid:remove(q.sep)
        q.label:delete()
        q.answers:delete()
        q.sep:delete()
    end
    questions = {}
    grid:resize(1,3)
end

