[Setting name="I am 18 years old or older and I understand this plugin might show content unsuitable for children" category="Important!" description="If this checkbox is disabled, the plugin will not display anything."]
bool Setting_isOverEighteen=false;

[Setting hidden]
bool Setting_FirstTimeUse=true;

[Setting name="Height of the browser window" category="Window" min=1 max=1080]
int Window_Height = int(Draw::GetHeight()*0.6);

[Setting name="Width of the browser window" category="Window" min=1 max=1920]
int Window_Width = int(Draw::GetWidth()*0.4);

[Setting name="Limit of posts" category="Query"]
int Query_searchLimit = 10;


