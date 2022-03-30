Envoy is an opensource edge and service proxy for service mesh, which has the ability routing and filtering requests to different upstream clusters. We will use Hyperscan matcher to replace the default RE2 regex matcher to accelerate regex matching in Envoy. Hyperscan is a Intel-led open source regex engine which benefits from SIMD instructions including AVX2 and AVX512. 

