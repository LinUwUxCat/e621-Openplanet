bool browserShown = false;
bool maintenance = false;
string inputTags = "";
Json::Value jsonResult = Json::Parse('{"loading" : false}');
array<Post> openPosts;
int spaceAvailable;
int newTab=-1;
int currentPage = 1;
const vec4 TAG_SPECIES = vec4(0.9, 0.2, 0.2, 1);
const vec4 TAG_ARTIST = vec4(0.7, 0.4, 0.0, 1);
const vec4 TAG_COPYRIGHT = vec4(0.9, 0.0, 0.7, 1);
const vec4 TAG_CHARACTER = vec4(0.1, 0.9, 0.1, 1);
const vec4 TAG_GENERAL = vec4(0.3, 0.3, 1, 1);
const vec4 TAG_META = vec4(0.1, 0.1, 0.1, 1);
const vec2 BUTTON_PADDING = vec2(12, 12);
UI::Font@ bigFont;
UI::Font@ sideFont;

void Main(){
    if(Setting_FirstTimeUse){
        Setting_FirstTimeUse=false;
        UI::ShowNotification(Icons::Paw + " e621 browser", "Please head to the settings to enable the plugin!", UI::HSV(0.33, 0.33, 0.33), 10000);
    }
    if (!Setting_isOverEighteen) return;
    @bigFont = UI::LoadFont("DroidSans-Bold.ttf", 32);
    @sideFont = UI::LoadFont("DroidSans.ttf", 22);
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
        if(maintenance){
            UI::Text("e621 is in maintenance - please try again later!");
            if (ColoredButton("Retry", vec4(1, 0.05, 0.05, 1), Draw::MeasureString("Retry")+BUTTON_PADDING)){
                maintenance=false;
                jsonResult = Json::Parse('{"loading" : false}');
            }
            UI::End();
            return;
        }
        UI::BeginTabBar("Tabs");
        if(UI::BeginTabItem(Icons::Paw + "Browse")){
            inputTags = UI::InputText("Enter some tags", inputTags, 0);
            UI::SameLine();
            bool clicked =  UI::Button("Search");
            if (clicked){
                array<string> searchTags = inputTags.Split(" ");
                auto tagsBox = Tags(searchTags, currentPage);
                startnew(getFromE, tagsBox); 
            }
            bool loading = true;
            try{
                loading = jsonResult['loading'];
            } catch {
                if(jsonResult == null){
                    maintenance = true;
                    UI::EndTabItem();
                    UI::EndTabBar();
                    UI::End();
                } //else, idfk.
            }
            
            
            
            if (loading){
                UI::Text("Loading...");
            } else if (jsonResult != null && jsonResult.HasKey('posts')){
                if(UI::BeginTable("images", Window_ImagesPerRow)){
                    for (int i = 0; i<Query_searchLimit; i++){
                        UI::TableNextColumn();
                        try{
                            if(jsonResult['posts'].Length==0){
                                UI::Text("No results!");
                            }
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
                                if (UI::IsItemClicked()){
                                    bool add=true;
                                    for(uint p = 0; p<openPosts.Length; p++){
                                        uint64 id = jsonResult['posts'][i]['id'];
                                        if (openPosts[p].getId()==id){
                                            add=false;
                                             newTab=p;
                                        }
                                    }
                                    if(add){
                                        openPosts.InsertLast(Post(jsonResult['posts'][i]));
                                        newTab=openPosts.Length-1;
                                    }
                                } 
                            } else {
                                UI::Text("Image is loading...");
                            }
                        } catch {
                            UI::Text("This image has blacklisted tags!");
                        }
                    }
                    UI::EndTable();
                    if(UI::Button("Previous"))currentPage--;
                    if(UI::Button("Next"))currentPage++;
                }
            } else {
                UI::Text("No search yet!");
            }
            UI::EndTabItem();
        }
        for(uint i = 0; i<openPosts.Length; i++){
            bool open = true;
            string name = "#" + openPosts[i].getId();
            if (name=="#") continue;
            if(UI::BeginTabItem(name, open, newTab==i?UI::TabItemFlags::SetSelected:0)){
                if(newTab>-1)newTab=-1;
                if(UI::BeginTable("postpage", 2, UI::TableFlags::SizingStretchProp)){
                    UI::TableSetupColumn("", UI::TableColumnFlags::WidthFixed);
                    UI::TableSetupColumn("", UI::TableColumnFlags::WidthFixed);
                    UI::TableNextColumn();
                    auto img = Images::CachedFromURL(Setting_LowResImages ? openPosts[i].getSampleUrl() : openPosts[i].getUrl());
                    if (img.m_texture !is null){
                        vec2 thumbSize = img.m_texture.GetSize();
                        float ratio = Math::Min((UI::GetWindowSize().x / 1.4)/thumbSize.x, (UI::GetWindowSize().y - 100) /thumbSize.y);
                        UI::Image(img.m_texture, vec2(
                            thumbSize.x * ratio,
                            thumbSize.y * ratio
                        ));
                    } else {
                        UI::Text("Image is loading...");
                    }
                    if (UI::IsItemHovered()) {
                        UI::BeginTooltip();
                        auto timg = Images::CachedFromURL(openPosts[i].getUrl());
                        if (timg.m_texture !is null){
                            vec2 thumbSize = timg.m_texture.GetSize();
                            float ratio = Math::Min((Draw::GetWidth()-UI::GetMousePos().x) / thumbSize.x, (Draw::GetHeight()-UI::GetMousePos().y) / thumbSize.y);
                            UI::Image(timg.m_texture, vec2(
                                thumbSize.x*ratio,
                                thumbSize.y*ratio
                            ));
                        } else {
                            UI::Text("Image is loading...");
                        }
                        UI::EndTooltip();
                    }
                    UI::TableNextColumn();
                    UI::PushFont(bigFont);
                    UI::Text(name);
                    UI::PopFont();
                    UI::PushFont(sideFont);
                    string artists;
                    for (uint a = 0; a<openPosts[i].artistTags().Length; a++){
                        artists += openPosts[i].artistTags()[a];
                        if (openPosts[i].artistTags().Length-1 ==a){
                            UI::Text("Artist" + (openPosts[i].artistTags().Length > 1? "s : " : " : ") + artists);
                        } else {
                            artists += ", ";
                        }
                    }
                    vec3 score = openPosts[i].getScore();
                    if (score.x>0){
                        UI::Text("Score : \\$0f0" + score.x);
                    } else if (score.x < 0){
                        UI::Text("Score : \\$f00" + score.x);
                    } else {
                        UI::Text("Score : \\$bb0" + score.x);
                    }
                    if (UI::IsItemHovered()){
                        UI::BeginTooltip();
                        UI::Text("\\$0f0" + score.y + "\\$f00" + score.z);
                        UI::EndTooltip();
                    }
                    UI::Text("Rating : " + openPosts[i].getRating(true));
                    UI::PopFont();

                    UI::EndTable();
                }
                spaceAvailable = UI::GetWindowSize().x;
                
                renderTagList(openPosts[i].artistTags(), TAG_ARTIST);
                renderTagList(openPosts[i].copyrightTags(), TAG_COPYRIGHT);
                renderTagList(openPosts[i].characterTags(), TAG_CHARACTER);
                renderTagList(openPosts[i].speciesTags(), TAG_SPECIES);
                renderTagList(openPosts[i].generalTags(), TAG_GENERAL);
                renderTagList(openPosts[i].metaTags(), TAG_META);
                
                
                UI::EndTabItem();
            }
            if (!open){
                openPosts.RemoveAt(i--);
            }
        }
        UI::EndTabBar();
    }
    UI::End();
}