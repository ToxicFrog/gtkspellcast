#include <stdio.h>
#include <glade.h>
#include <gtk.h>

> ctx = gtks.library()
> gtk,glade = ctx.gtk, ctx.glade
> gtk.init()
>>      'gtk_init'
<<      ok
> xml = glade.xml_new("ui/help.lua", "About", nil)
>>      'glade_xml_new' 'ui/help.lua' 'About' NULL

(<unknown>:19522): libglade-WARNING **: could not find glade file 'ui/help.lua'
<<      0
> xml = glade.xml_new("ui/help.glade", "About", nil)
>>      'glade_xml_new' 'ui/help.glade' 'About' NULL
<<      153004360
> print(xml)
153004360
> print(glade.xml_get_widget(xml, "About"))
>>      'glade_xml_get_widget' '153004360' 'About'
<<      153219288
153219288
> print(glade.xml_get_widget(xml, "Rules"))
>>      'glade_xml_get_widget' '153004360' 'Rules'
<<      153274440
153274440

