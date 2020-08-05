import QtQuick 2.0
import QtQuick.Controls 2.4


Item
{
    id: element1

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.fill: parent

        Button
        {
            x: 521
            text: qsTr("Back")
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 15

            onClicked:
            {
                uicontroller.infoPageStatus = false
            }
        }
    }


    Rectangle
    {
        id:versionBlock
        width: 300
        height: 50
        clip: true
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 15
        anchors.topMargin: 15

        Image
        {
            id:versionLogo
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            height: 35
            fillMode: Image.PreserveAspectFit
            width: 35
            source: "/icons/Stackoverflow.png"

        }

        Text
        {
            id:versionNoText
            width: 50
            anchors.left: versionLogo.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Version: ")
            horizontalAlignment: Text.AlignRight
        }

        Text
        {
            id:versionNo
            anchors.left: versionNoText.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            text: qsTr("1.0.0")
        }
    }



    Rectangle
    {
        id:producerBlock
        height: 100
        anchors.right: parent.right
        anchors.rightMargin: 15
        clip: true
        anchors.left: parent.left
        anchors.top: versionBlock.bottom
        anchors.leftMargin: 15
        anchors.topMargin: 15

        Image
        {
            id: producerLogo
            anchors.left: parent.left
            anchors.top: parent.top
            // anchors.bottom: parent.bottom
            height: 35
            fillMode: Image.PreserveAspectFit
            width: 35
            source: "/icons/MTLogo.png"
        }

        Text
        {
            id:producerText
            anchors.left: producerLogo.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignTop
            text: qsTr("Producer: ")
            horizontalAlignment: Text.AlignRight
        }

        Column
        {
            id:addressText
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: producerText.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            spacing: 2

            Text
            {
                text: "MediTECH Electronic GmbH"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }
            Text
            {
                text: "Langer Acker 7"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }
            Text
            {
                text: "D-30900 Wedemark"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }
            Text
            {
                text: "Email: service@meditech.de"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }
        }
    }



    Button
    {
        anchors.left: parent.left
        anchors.top: producerBlock.bottom
        anchors.topMargin: 15
        text: qsTr("APP TOU - Terms of Agrement")
        anchors.leftMargin: 15

        onClicked:
        {
            uicontroller.agrementPageStatus = true
        }
    }






    Rectangle {
        id: togscreen
        color: "#ffffff"
        visible: uicontroller.agrementPageStatus
        clip: true
        anchors.fill: parent

        ScrollView
        {
            clip: true
            contentWidth: togscreen.width -30
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 15
            anchors.top: togback.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 15
            contentHeight: 1400

            Text {
                id: element
                y: 8
                height: 2000
                text: qsTr("End-User License Agreement (\"Agreement\")
Last updated: May 09, 2018
Please read this End-User License Agreement (\"Agreement\") carefully before clicking the \"I Agree\" button, downloading or using Audio Fitness (\"Application\").
By clicking the \"I Agree\" button, downloading or using the Application, you are agreeing to be bound by the terms and conditions of this Agreement.
This Agreement is a legal agreement between you (either an individual or a single entity) and MediTECH Electronic GmbH and it governs your use of the Application made available to you by MediTECH Electronic GmbH.
If you do not agree to the terms of this Agreement, do not click on the \"I Agree\" button and do not download or use the Application.
The Application is licensed, not sold, to you by MediTECH Electronic GmbH for use strictly in accordance with the terms of this Agreement.
License
MediTECH Electronic GmbH grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the Application solely for your personal, non-commercial purposes strictly in accordance with the terms of this Agreement.
Restrictions
You agree not to, and you will not permit others to:
license, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the Application or make the Application available to any third party.
copy or use the Application for any purpose other than as permitted under the above section 'License'.
modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the Application.
remove, alter or obscure any proprietary notice (including any notice of copyright or trademark) of MediTECH Electronic GmbH or its affiliates, partners, suppliers or the licensors of the Application.
Intellectual Property
The Application, including without limitation all copyrights, patents, trademarks, trade secrets and other intellectual property rights are, and shall remain, the sole and exclusive property of MediTECH Electronic GmbH.
Your Suggestions
Any feedback, comments, ideas, improvements or suggestions (collectively, \"Suggestions\") provided by you to MediTECH Electronic GmbH with respect to the Application shall remain the sole and exclusive property of MediTECH Electronic GmbH.
MediTECH Electronic GmbH shall be free to use, copy, modify, publish, or redistribute the Suggestions for any purpose and in any way without any credit or any compensation to you.
Modifications to Application
MediTECH Electronic GmbH reserves the right to modify, suspend or discontinue, temporarily or permanently, the Application or any service to which it connects, with or without notice and without liability to you.
Updates to Application
MediTECH Electronic GmbH may from time to time provide enhancements or improvements to the features/functionality of the Application, which may include patches, bug fixes, updates, upgrades and other modifications (\"Updates\").
Updates may modify or delete certain features and/or functionalities of the Application. You agree that MediTECH Electronic GmbH has no obligation to (i) provide any Updates, or (ii) continue to provide or enable any particular features and/or functionalities of the Application to you.
You further agree that all Updates will be (i) deemed to constitute an integral part of the Application, and (ii) subject to the terms and conditions of this Agreement.
Third-Party Services
The Application may display, include or make available third-party content (including data, information, applications and other products services) or provide links to third-party websites or services (\"Third-Party Services\").
You acknowledge and agree that MediTECH Electronic GmbH shall not be responsible for any Third-Party Services, including their accuracy, completeness, timeliness, validity, copyright compliance, legality, decency, quality or any other aspect thereof. MediTECH Electronic GmbH does not assume and shall not have any liability or responsibility to you or any other person or entity for any Third-Party Services.
Third-Party Services and links thereto are provided solely as a convenience to you and you access and use them entirely at your own risk and subject to such third parties' terms and conditions.
Privacy Policy
MediTECH Electronic GmbH collects, stores, maintains, and shares information about you in accordance with its Privacy Policy, which is available at http://privacy-policy.audiofitness.org. By accepting this Agreement, you acknowledge that you hereby agree and consent to the terms and conditions of our Privacy Policy.
Term and Termination
This Agreement shall remain in effect until terminated by you or MediTECH Electronic GmbH.
MediTECH Electronic GmbH may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.
This Agreement will terminate immediately, without prior notice from MediTECH Electronic GmbH, in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the Application and all copies thereof from your mobile device or from your computer.
Upon termination of this Agreement, you shall cease all use of the Application and delete all copies of the Application from your mobile device or from your computer.
Termination of this Agreement will not limit any of MediTECH Electronic GmbH's rights or remedies at law or in equity in case of breach by you (during the term of this Agreement) of any of your obligations under the present Agreement.
Indemnification
You agree to indemnify and hold MediTECH Electronic GmbH and its parents, subsidiaries, affiliates, officers, employees, agents, partners and licensors (if any) harmless from any claim or demand, including reasonable attorneys' fees, due to or arising out of your: (a) use of the Application; (b) violation of this Agreement or any law or regulation; or (c) violation of any right of a third party.
No Warranties
The Application is provided to you \"AS IS\" and \"AS AVAILABLE\" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, MediTECH Electronic GmbH, on its own behalf and on behalf of its affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Application, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement, and warranties that may arise out of course of dealing, course of performance, usage or trade practice. Without limitation to the foregoing, MediTECH Electronic GmbH provides no warranty or undertaking, and makes no representation of any kind that the Application will meet your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, operate without interruption, meet any performance or reliability standards or be error free or that any errors or defects can or will be corrected.
Without limiting the foregoing, neither MediTECH Electronic GmbH nor any MediTECH Electronic GmbH's provider makes any representation or warranty of any kind, express or implied: (i) as to the operation or availability of the Application, or the information, content, and materials or products included thereon; (ii) that the Application will be uninterrupted or error-free; (iii) as to the accuracy, reliability, or currency of any information or content provided through the Application; or (iv) that the Application, its servers, the content, or e-mails sent from or on behalf of MediTECH Electronic GmbH are free of viruses, scripts, trojan horses, worms, malware, timebombs or other harmful components.
Some jurisdictions do not allow the exclusion of or limitations on implied warranties or the limitations on the applicable statutory rights of a consumer, so some or all of the above exclusions and limitations may not apply to you.
Limitation of Liability
Notwithstanding any damages that you might incur, the entire liability of MediTECH Electronic GmbH and any of its suppliers under any provision of this Agreement and your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by you for the Application.
To the maximum extent permitted by applicable law, in no event shall MediTECH Electronic GmbH or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, for loss of data or other information, for business interruption, for personal injury, for loss of privacy arising out of or in any way related to the use of or inability to use the Application, third-party software and/or third-party hardware used with the Application, or otherwise in connection with any provision of this Agreement), even if MediTECH Electronic GmbH or any supplier has been advised of the possibility of such damages and even if the remedy fails of its essential purpose.
Some states/jurisdictions do not allow the exclusion or limitation of incidental or consequential damages, so the above limitation or exclusion may not apply to you.
Severability
If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.
Waiver
Except as provided herein, the failure to exercise a right or to require performance of an obligation under this Agreement shall not effect a party's ability to exercise such right or require such performance at any time thereafter nor shall be the waiver of a breach constitute waiver of any subsequent breach.
Amendments to this Agreement
MediTECH Electronic GmbH reserves the right, at its sole discretion, to modify or replace this Agreement at any time. If a revision is material we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.
By continuing to access or use our Application after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use the Application.
Governing Law
The laws of Lower Saxony, Germany, excluding its conflicts of law rules, shall govern this Agreement and your use of the Application. Your use of the Application may also be subject to other local, state, national, or international laws.
Contact Information
If you have any questions about this Agreement, please contact us.
Entire Agreement
The Agreement constitutes the entire agreement between you and MediTECH Electronic GmbH regarding your use of the Application and supersedes all prior and contemporaneous written or oral agreements between you and MediTECH Electronic GmbH.
You may be subject to additional terms and conditions that apply when you use or purchase other MediTECH Electronic GmbH's services, which MediTECH Electronic GmbH will provide to you at the time of such use or purchase.
")
                anchors.right: parent.right
anchors.left: parent.left
wrapMode: Text.WordWrap
            font.pixelSize: 12
        }

        }

        Button {
            id: togback
            x: 530
            text: qsTr("Back")
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 15

            onClicked:
            {
                uicontroller.agrementPageStatus = false
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:2;anchors_y:30}D{i:1;anchors_height:200;anchors_width:200}
D{i:10;anchors_width:160}D{i:7;anchors_width:500}D{i:15;anchors_height:200;anchors_width:200;anchors_x:330;anchors_y:250}
D{i:18;anchors_y:8}D{i:17;anchors_y:8}D{i:19;anchors_y:8}D{i:16;anchors_height:200;anchors_width:200;anchors_x:330;anchors_y:250}
}
##^##*/
