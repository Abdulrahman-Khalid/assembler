# COMMENT
###########################

.ORG 1e     #comment
inc R1        
Br label1   #31 br rqm => 31 + (rqm) = 35
MoV R1,R2   #comment
dec R2
Add R4,R2
label1:
add R4,R2
HLT
