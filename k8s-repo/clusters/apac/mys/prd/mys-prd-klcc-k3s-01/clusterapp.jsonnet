local p = import 'params.libsonnet';
## to update the libs path. jsonnet termination `;` libsonnet termination `,`
local clustermgmt = import '/libs/clustermanagment.libsonnet'; 
clustermgmt.BaseClusterApp(p)

