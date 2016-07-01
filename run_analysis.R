# Get features & activities names
x.header=read.table("features.txt", header=F)
x.header=x.header$V2
act.label=read.table("activity_labels.txt", header=F)

# Merge test data
subject.test=read.table("subject_test.txt", header=F, col.names = "Subject")
x.test=read.table("X_test.txt", header=F, col.names=x.header)
y.test=read.table("Y_test.txt", header=F, col.names="Activity")
type=rep("test",nrow(subject.test))
test.data=cbind(subject.test,y.test,x.test, type)

# Merge training data
subject.train=read.table("subject_train.txt", header=F, col.names = "Subject")
x.train=read.table("X_train.txt", header=F, col.names=x.header)
y.train=read.table("Y_train.txt", header=F, col.names="Activity")
type=rep("training", nrow(x.train))
train.data=cbind(subject.train,y.train,x.train, type)

# Merge all data
complete.data=rbind(train.data,test.data)

# Filter activity names for Mean & Std Dev
filt.act.m=grep("mean", x.header)
filt.act.s=grep("std", x.header)
filt.num=sort(c(filt.act.s,filt.act.m))
filt.act=x.header[filt.num]

# Filter data with Mean & Std Dev
complete.data=complete.data[,filt.num]

# Rename dataset columns & Activities
clean.name=gsub("/(/)","", names(complete.data))
clean.name=gsub("[.]","", clean.name)
names(complete.data)=clean.name
complete.data$Activity=factor(complete.data$Activity,levels=act.label$V1,labels = act.label$V2)

# Create tidy dataset

measure=colnames(complete.data[,-(1:2)])
melt.data=melt(complete.data, id=c("Subject", "Activity"), measure.vars=measure)
tidy.data=dcast(melt.data, Subject + Activity ~ variable, mean)
write.table(tidy.data, file="tidydata.txt", row.names = F)
