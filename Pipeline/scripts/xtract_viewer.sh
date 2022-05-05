#!/bin/bash
FSLDIR=/usr/local/fsl 
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

xtract_viewer -dir ~/Pipeline/XtractOutputs/sub_02/XtractOut_02 -species HUMAN #-str ac,af_l,af_r,ar_l,atr_l,atr_r,cbd_l,cbd_r,cbp_l,cbp_r,cbt_l,cbt_r,cst_l,cst_r,fa_l,fa_r,fma,fmi,fx_l,fx_r,ifo_l,ifo_r,ilf_l,ilf_r,mcp,mdlf_l,mdlf_r,or_l,or_r,slf1_l,slf1_r,slf2_l,slf2_r,slf_3_l,slf3_r,str_l,str_r,uf_l,uf_r,vof_l,vof_r
