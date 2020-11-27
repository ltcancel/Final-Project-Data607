#this is an example of format_df() with a test data frame

cols_to_match<-colnames(df)
#cols_to_match<-list("one","two","three")
#remove the DocType Column for alphabetization
df_to_mutate<-df%>%
  select(-DocType)
#order df alphabetically
df_to_mutate<-df_to_mutate[,order(colnames(df_to_mutate))]

#check if alpabetized
#view(df_to_mutate[1:10,1:10])

#FOR TEST, make a data frame with randomly selected rows from df_to_mutate
make_df<-function(number_of_columns){
#prime variable "i"
i=0
#prime rng
n<-sample(1:ncol(df_to_mutate),1)
used_list<-list()
#prime rows for our new data frame
df2<-df_to_mutate[,n]
#loop to build the df with the right number of columns   
while(i<number_of_columns){
  cat("running loop ",i,"\n")
#get a random column that has not already been selected
while(n%in%used_list==TRUE){
  n<-sample(1:ncol(df_to_mutate),1)
}
#add to used column list
used_list<-append(used_list,n)
#print(used_list)
#set val equal to the name of the column
val<-colnames(df_to_mutate[n])
#print(val)
#add column to new df
  df2<-cbind(df2,df_to_mutate[,n])
  #print(colnames(df2))
  i=i+1
}
return(df2)
}


temp<-make_df(600)

#temp is now an out of order corpus with less words than are in our master

#alphabetize test matrix
temp<-temp[,order(colnames(temp))]

#check if alpabetized

#function to add in columns that need to exist and remove columns that need to be removed

format_df<-function(input_df,reference_df){

#remove "DocType" column if it exists in the reference df
if("DocType"%in%colnames(reference_cols)==TRUE){
  reference_cols<-reference_cols%>%
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

temp2<-format_df(temp,df)
view(colnames(temp2))
df<-df[,order(colnames(df))]
view(colnames(df))
