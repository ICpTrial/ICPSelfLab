# ICP入門 セルフ・ハンズオン 

このセルフ・ハンズオンは、ICP Cloud Private Cloud Native エディション または IBM Cloud Private Community エディションを利用して、
利用者の方が自習できるよう想定しています。
ハンズオン環境としては、ICPがサポートするバージョンの Linux環境を各自用意して自習を進めてください。<br>
Ubuntu環境で検証をしていますが、その他のサポート環境であっても動くはずです。コマンドの差異などは適宜読み替えて自習を進めてください。
また、多少の問題があっても、自力で問題を解決できる技術者を想定しています。

ハンズオン検証環境： Ubuntu v16.0.4 LTS (8vCPU, 32GB Memory, 100GB)<br>
[講義資料](https://ibm.box.com/s/a3ms8gsmsd1iidk0b4yvhr0g905kgv2e)<br>
時間は目安ですが、一日で終わらせるのはなかなかたいへんだとは思います…

|章|内容|時間|ハンズオン内容|
|--|---|---|---------------------------|
|1|Docker入門 講義|10:00-10:30| |
|2|Dockerハンズオン|10:30-11:00|[Lab1: Dockerの導入](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab1_DockerInstall.md)<br>[Lab2: Docker基礎 Apache Http Serverを利用して](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab2_DockerBasic.md)<br>[Lab3: Dockerfile による Libertyイメージのビルド](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab3_CreateDockerfile.md)|
|3|ICP導入ハンズオン|11:00-11:30|[Lab4: IBM Cloud Privateの導入](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab4_ICPInstall.md)|
|4|Kubernetes入門 講義1|11:30-12:00| |
|5|Kubernetes入門 講義2|13:00-14:00| |
|6|Kubernetes ハンズオン|14:00-15:30|[Lab5: コンソールを利用してHELMからのLibertyのインストール](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab5_ICPconsole.md)<br>[Lab6: 独自Libertyイメージを利用してのインストール](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab6_kubeDeployOnICP.md)<br>[Lab7: 作成した定義のHELMへのパッケージング](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab7_Helm.md)<br>[参考: IBM Community Chart Guideline](https://github.com/ICpTrial/ICPSelfLab/blob/master/IBMCommunityChartGuideline.md)|
|7|ICPの拡張機能 講義|15:30-16:00| |
|8|ICPのセキュリティ 講義|16:00-16:30| |
|9|ICPハンズオン オプション|16:30-18:00|[Lab8: Microclimateを利用した新規アプリケーションの開発](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab8_Microclimate.md)<br>[Lab9: Transformation Advisorを利用した既存システムのモダナイズ](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab9_TransformationAdvisor.md)<br>[Lab10: ImagePolicyとユーザー管理](https://github.com/ICpTrial/ICPSelfLab/blob/master/Lab10_UserManagement.md)|
|10|Free Discussion |18:00- | |

シナリオの間違い、不備、誤字脱字 に関しては、Pull Request でご連絡ください。ハンズオン品質の向上にご協力いただき感謝します。
