format_df<-function(input_df,reference_df){
  
  #remove "DocType" column if it exists in the reference df
  if("DocType"%in%colnames(reference_cols)==TRUE){
    reference_df<-reference_df%>%
      select(-DocType)
  }
  #get column names as lists for each DF
  input_cols<-colnames(input_df)
  reference_cols<-colnames(reference_df)
  
  
  
  #remove unwanted columns
  i=1
  cols_removed<-0
  while(i<ncol(input_df)){
    if((input_cols[i]%in%reference_cols)==FALSE){
      input_df<-input_df%>%
        select(-colnames(input_df[i]))
      cols_removed<-cols_removed+1
    }
    i=i+1
  }
  
  
  
  #add necessary columns with values set to zero
  j=1
  cols_added<-0
  while(j<ncol(reference_df)){
    if(reference_cols[j]%in%input_cols==FALSE){
      #set all values equal to zero
      reference_df[j]<-lapply(reference_df[,j],function(x){x*0})
      #cbind the new column to input_df
      input_df<-cbind(input_df,reference_df[j])
      cols_added<-cols_added+1
    }
    j=j+1
  }
  
  
  #alphabetize output_df
  output_df<-input_df[,order(colnames(input_df))]
  #print number of columns added and removed
  cat("number of columns removed:",cols_removed,"\n","number of columns added:",cols_added)
  return(output_df)
}
