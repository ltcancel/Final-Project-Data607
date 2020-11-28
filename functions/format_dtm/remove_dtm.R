remove_dtm<-function(input_df,reference_df){
  
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
  #print(length(vars_to_remove))
  input_df<-input_df%>%
    select(-vars_to_remove)
  output_df<-input_df
  
  #alphabetize output_df
  #output_df<-input_df[,order(colnames(input_df))]
  #print number of columns added and removed
  cat("number of columns removed:",cols_removed,"\n")
  return(output_df)
}
