library(dplyr)

path_X_train="./data/train/X_train.txt"
path_X_test="./data/test/X_test.txt"

path_train_y="./data/train/y_train.txt"
path_test_y="./data/test/y_test.txt"

path_subject_train="./data/train/subject_train.txt"
path_subject_test="./data/test/subject_test.txt"

path_features="./data/features.txt"

train_data<-read.table(path_X_train,sep="",header=FALSE)
test_data<-read.table(path_X_test,sep="",header=FALSE)

train_y<-read.table(path_train_y,sep="",header=FALSE)
test_y<-read.table(path_test_y,sep="",header=FALSE)

subject_train<-read.table(path_subject_train,sep="",header=FALSE)
subject_test<-read.table(path_subject_test,sep="",header=FALSE)

features<-read.table(path_features,sep="",header=FALSE)

names(train_data)<-features$V2
names(test_data)<-features$V2

names(train_y)<-"Activity_Label"
names(test_y)<-"Activity_Label"

names(subject_train)<-"subject"
names(subject_test)<-"subject"

train_<-cbind(train_data,train_y)
train<-cbind(train_,subject_train)
test_<-cbind(test_data,test_y)
test<-cbind(test_,subject_test)

data_input<-rbind(train,test)

names(data_input)<-gsub("\\(\\)","",names(data_input))
data_input_te<-data_input[,-(461:502)]

data_input_filtered<-select(data_input_te,contains("mean"),contains("std"),Activity_Label,subject)

activity_label<-read.table("./data/activity_labels.txt",sep="",header=FALSE)
names(activity_label)<-c("activity_label","label_description")

data_final_step_4<-merge(data_input_filtered,activity_label,by.x="Activity_Label",by.y="activity_label",all.x=TRUE)

data_final_step_5_1<-group_by(data_final_step_4,Activity_Label,subject)

data_final_step_5<-summarise_at(data_final_step_5_1,vars(matches("mean|std")), funs(mean(., na.rm = TRUE)))
