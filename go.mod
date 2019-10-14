module github.com/nsm-istio

go 1.12

require (
	github.com/hashicorp/go-multierror v1.0.0
	github.com/spf13/cobra v0.0.5
	github.com/spf13/viper v1.4.0
	istio.io/istio v0.0.0-20191002014124-994079266c63
	istio.io/pkg v0.0.0-20190905225920-6d0bbfe3b229
	k8s.io/api v0.0.0
	k8s.io/apimachinery v0.0.0
	k8s.io/client-go v11.0.1-0.20190409021438-1a26190bd76a+incompatible
	k8s.io/klog v1.0.0 // indirect
)

replace (
	github.com/spf13/viper => github.com/istio/viper v1.3.3-0.20190515210538-2789fed3109c
	istio.io/istio => ../../istio.io/istio
	k8s.io/api => k8s.io/api v0.0.0-20190222213804-5cb15d344471
	k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.0.0-20190221221350-bfb440be4b87
	k8s.io/apimachinery => k8s.io/apimachinery v0.0.0-20190221213512-86fb29eff628
	k8s.io/cli-runtime => k8s.io/cli-runtime v0.0.0-20190221101700-11047e25a94a
	k8s.io/client-go => k8s.io/client-go v10.0.0+incompatible
)
