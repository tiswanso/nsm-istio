apiVersion: apps/v1
kind: Deployment
metadata:
  name: nsm-svc-reg
  namespace: {{ .Release.Namespace }}
spec:
  selector:
    matchLabels:
      run: nsm-svc-reg
  replicas: 1
  template:
    metadata:
      labels:
        run: nsm-svc-reg
    spec:
      containers:
        - name: nsm-svc-reg
          image: {{ .Values.registry }}/{{ .Values.org }}/nsm_svc_reg:{{ .Values.tag }}
          imagePullPolicy: {{ .Values.pullPolicy }}
          command: [ "/usr/bin/nsm_svc_reg", "pod-watcher" ]
          args: [ "--kubeconfig", "/etc/svcreg/kubeconfig", "--kubeconfigremote", "/etc/remote/kubeconfig", "-a", "$(NAMESPACE)" ]
          env:
          - name: NAMESPACE
            value: {{ .Values.watchNamespace }}
          volumeMounts:
          - name: svcregclusterdata
            mountPath: "/etc/svcreg"
            readOnly: true
          - name: remoteclusterdata
            mountPath: "/etc/remote"
            readOnly: true
      volumes:
      - name: svcregclusterdata
        secret:
          secretName: {{ .Values.svcRegKubeConfigSecret }}
      - name: remoteclusterdata
        secret:
          secretName: {{ .Values.watchKubeConfigSecret }}
