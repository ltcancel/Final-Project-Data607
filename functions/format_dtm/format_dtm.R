format_dtm<-function(input_df,reference_df){
  
  #get column names as lists for each DF
  input_cols<-colnames(input_df)
  reference_cols<-colnames(reference_df)
  
  #remove "DocType" column if it exists in the reference df
  if("DocType"%in%colnames(reference_cols)==TRUE){
    reference_df<-reference_df%>%
      select(-DocType)
  }
  
  
  
  
  #remove unwanted columns
  i=1
  cols_removed<-0
  vars_to_remove<-vector()
  while(i<ncol(input_df)){
    pattern<-paste0("^",input_cols[i],"$")
    if(all(str_detect(colnames(reference_df),pattern,negate=TRUE))){
      vars_to_remove<-append(vars_to_remove,as.numeric(i))
      cols_removed<-cols_removed+1
    }
    i=i+1
    
    
  }
  
  input_df<-input_df%>%
    select(-vars_to_remove)
  
  output_df<-input_df
  
  
  
  #add necessary columns with values set to zero
  j=1
  cols_added<-0
  #priming temp_df
  xxx<-rep(0, nrow(input_df))
  temp_df<-data.frame(xxx)
  while(j<ncol(reference_df)){
    pattern<-paste0("^",reference_cols[j],"$")
    if(!any(str_detect(colnames(input_df),pattern))){
      #set all values equal to zero
      #reference_df[j]<-lapply(reference_df[j],function(x){x*0})
      
      #create a temporary column
      temp_col<-rep(0, nrow(input_df))
      #add it to the input_df
      temp_df$temp_col<-temp_col
      #rename temp_col with correct word
      
      #coerce column name to a name, not sure if i need this
      #name=as.name(reference_cols[j])
      temp_df<-temp_df%>%
        rename(
          !!reference_cols[j] :=temp_col
        )
      cols_added<-cols_added+1
    }
    j=j+1
  }
  temp_df<-temp_df%>%
    select(-xxx)
  output_df<-input_df
  output_df<-cbind(output_df,temp_df)
  
  
  #alphabetize output_df
  #output_df<-input_df[,order(colnames(input_df))]
  #print number of columns added and removed
  cat("number of columns removed:",cols_removed,"\n","number of columns added:",cols_added)
  return(output_df)
}
