bool browserShown = false;
string inputTags = "";
Json::Value jsonResult = Json::Parse('{"loading" : false}');
array<Post> openPosts; //TODO : switch to dict
void Main(){
    if(Setting_FirstTimeUse){
        Setting_FirstTimeUse=false;
        UI::ShowNotification(Icons::Paw + " e621 browser", "Please head to the settings to enable the plugin!", UI::HSV(0.33, 0.33, 0.33), 10000);
    }
    if (!Setting_isOverEighteen) return;
    print("Hello world!");
}

void RenderMenu(){
    if (!Setting_isOverEighteen) return;
    if(UI::MenuItem(Icons::Paw+" e621 browser window", "", browserShown)){
        browserShown = !browserShown;
    }
}

void Render(){
    if (!Setting_isOverEighteen) return;
    if (!browserShown) return;

    UI::SetNextWindowSize(Window_Size.x, Window_Size.y);
    UI::SetNextWindowPos(50, 50);
    if (UI::Begin(Icons::Paw + " e621 browser", browserShown, UI::WindowFlags::NoCollapse | UI::WindowFlags::HorizontalScrollbar)){
        Window_Size = UI::GetWindowSize();
        UI::BeginTabBar("Tabs");
        if(UI::BeginTabItem(Icons::Paw + "Browse")){
            inputTags = UI::InputText("Enter some tags", inputTags, 0);
            bool clicked =  UI::Button("Search");
            if (clicked){
                array<string> searchTags = inputTags.Split(" ");
                auto tagsBox = Tags(searchTags);
                startnew(getFromE, tagsBox); 
            }
            bool loading = jsonResult['loading'];
            if (loading){
                UI::Text("Loading...");
            } else if (jsonResult.HasKey('posts')){
                string s = "";
                if(UI::BeginTable("images", Window_ImagesPerRow)){
                    for (int i = 0; i<Query_searchLimit; i++){
                        UI::TableNextColumn();
                        try{
                            if(jsonResult['posts'].Length == i) break;
                            if (!jsonResult['posts'][i].HasKey('file') || !jsonResult['posts'][i].HasKey('preview')) break;
                            string ext = jsonResult['posts'][i]['file']['ext'];
                            if(ext != "png" && ext != "jpg") continue;
                            string imgLink = jsonResult['posts'][i][Setting_LowResImages ? 'sample' : 'file']['url'];
                            auto img = Images::CachedFromURL(imgLink);
                            if (img.m_texture !is null){
                                vec2 thumbSize = img.m_texture.GetSize();
                                UI::Image(img.m_texture, vec2(
                                    UI::GetWindowSize().x/Window_ImagesPerRow - Window_ImageGap,
                                    thumbSize.y * ((UI::GetWindowSize().x/Window_ImagesPerRow - 30)/thumbSize.x)
                                ));
                                if (UI::IsItemClicked()) openPosts.InsertLast(Post(jsonResult['posts'][i]));
                            } else {
                                UI::Text("Image is loading...");
                            }
                        } catch {
                            UI::Text("This image has blacklisted tags!");
                        }
                    }
                    UI::Text(s);
                    UI::EndTable();
                }
            } else {
                UI::Text("No search yet!");
            }
            UI::EndTabItem();
        }
        for(uint i = 0; i<openPosts.Length; i++){
            string name = "#" + openPosts[i].getId();
            if (name=="#") continue;
            if(UI::BeginTabItem(name)){
                auto img = Images::CachedFromURL(Setting_LowResImages ? openPosts[i].getSampleUrl() : openPosts[i].getUrl());
                if (img.m_texture !is null){
                    vec2 thumbSize = img.m_texture.GetSize();
                    UI::Image(img.m_texture, vec2(
                        UI::GetWindowSize().x,
                        thumbSize.y * ((UI::GetWindowSize().x)/thumbSize.x)
                    ));
                } else {
                    UI::Text("Image is loading...");
                }
                if (UI::IsItemHovered()) {
                    UI::BeginTooltip();
                    auto timg = Images::CachedFromURL(openPosts[i].getUrl());
                    if (timg.m_texture !is null){
                        vec2 thumbSize = timg.m_texture.GetSize();
                        UI::Image(timg.m_texture, vec2(
                            Draw::GetWidth()/1.2,
                            thumbSize.y * ((Draw::GetWidth()/1.2)/thumbSize.x)
                        ));
                    } else {
                        UI::Text("Image is loading...");
                    }
                    UI::EndTooltip();
                }
                UI::EndTabItem();
            }
        }
        UI::EndTabBar();
    }
    UI::End();
}