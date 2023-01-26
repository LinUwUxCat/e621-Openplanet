[Setting name="I am 18 years old or older and I understand this plugin might show content unsuitable for children" category="e621" description="If this checkbox is disabled, the plugin will not display anything."]
bool Setting_isOverEighteen=false;

[Setting name="e926 switch" description="Toggle this if you want to u_se e926.net instead of e621.net"]
bool is926 = true;

[Setting hidden]
bool Setting_FirstTimeUse=true;

[Setting hidden]
bool Setting_VerboseLog=true;

[Setting hidden name="Width and height of the browser window" category="Window"]
vec2 Window_Size = vec2(Draw::GetWidth()*0.5, Draw::GetHeight()*0.6);

[Setting name="Number of Images per row" category="Window" min=1 max=10]
int Window_ImagesPerRow = 2;

[Setting name="Gap between the images" category="Window" min=0 max=100]
int Window_ImageGap = 20;

[Setting name="Limit of posts" category="e621"]
int Query_searchLimit = 10;

[Setting name="Load preview instead of full image" category="e621" description="This will load images that have a lower quality. The difference is barely noticeable in the browser but becomes more apparent when looking at the image."]
bool Setting_LowResImages = false;
