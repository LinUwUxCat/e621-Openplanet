class Tags{
    array<string> tags;
    Tags(array<string> s){
        tags = s;
    }
    string toUrl(){
        string r;
        for (uint i=0; i<this.tags.Length; i++){
            r += this.tags[i];
            if (i!=this.tags.Length-1) r+="+";
        }
        return r;
    }
};