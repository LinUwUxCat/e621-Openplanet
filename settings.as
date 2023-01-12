[Setting name="I am 18 years old or older and I understand this plugin might show content unsuitable for children" category="e621" description="If this checkbox is disabled, the plugin will not display anything."]
bool Setting_isOverEighteen=false;

[Setting hidden]
bool Setting_FirstTimeUse=true;

[Setting hidden]
bool Setting_VerboseLog=true;

[Setting name="Height of the browser window" category="Window" min=1 max=1080]
int Window_Height = int(Draw::GetHeight()*0.6);

[Setting name="Width of the browser window" category="Window" min=1 max=1920]
int Window_Width = int(Draw::GetWidth()*0.4);

[Setting name="Number of Images per row" category="Window" min=1 max=10]
int Window_ImagesPerRow = 2;

[Setting name="Gap between the images" category="Window" min=0 max=100]
int Window_ImageGap = 20;

[Setting name="Limit of posts" category="e621"]
int Query_searchLimit = 10;

[Setting name="Load preview instead of full image" category="e621" description="This will load lower quality images, which are low-res but weight a lot less so they download quicker."]
bool Setting_LowResImages = false;
