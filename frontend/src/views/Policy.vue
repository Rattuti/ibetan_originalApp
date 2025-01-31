<template>
  <navHeaderBar />
  <div class="privacy-policy">
      <h1>プライバシーポリシー</h1>
  
      <section>
        <h2>お客様から取得する情報</h2>
        <p>当社は、お客様から以下の情報を取得します。</p>
        <ul>
          <li>氏名(ニックネームやペンネームも含む)</li>
          <li>メールアドレス</li>
          <li>写真や動画</li>
        </ul>
      </section>
  
      <section>
        <h2>お客様の情報を利用する目的</h2>
        <p>当社は、お客様から取得した情報を、以下の目的のために利用します。</p>
        <ul>
          <li>当社サービスに関する登録の受付、お客様の本人確認、認証のため</li>
          <li>お客様の当社サービスの利用履歴を管理するため</li>
          <li>利用料金の決済のため</li>
          <li>当社サービスにおけるお客様の行動履歴を分析し、当社サービスの維持改善に役立てるため</li>
          <li>当社のサービスに関するご案内をするため</li>
          <li>お客様からのお問い合わせに対応するため</li>
          <li>当社の規約や法令に違反する行為に対応するため</li>
          <li>当社サービスの変更、提供中止、終了、契約解除をご連絡するため</li>
          <li>当社規約の変更等を通知するため</li>
          <li>以上の他、当社サービスの提供、維持、保護及び改善のため</li>
        </ul>
      </section>
  
      <section>
        <h2>安全管理のために講じた措置</h2>
        <p>
          当社が、お客様から取得した情報に関して安全管理のために講じた措置につきましては、
          末尾記載のお問い合わせ先にご連絡をいただきましたら、法令の定めに従い個別にご回答させていただきます。
        </p>
      </section>
  
      <section>
        <h2>第三者提供</h2>
        <p>
          当社は、お客様から取得する情報のうち、個人データ（個人情報保護法第１６条第３項）に該当するものついては、
          あらかじめお客様の同意を得ずに、第三者（日本国外にある者を含みます。）に提供しません。
        </p>
        <p>但し、次の場合は除きます。</p>
        <ul>
          <li>個人データの取扱いを外部に委託する場合</li>
          <li>当社や当社サービスが買収された場合</li>
          <li>事業パートナーと共同利用する場合（具体的な共同利用がある場合は、その内容を別途公表します。）</li>
          <li>その他、法律によって合法的に第三者提供が許されている場合</li>
        </ul>
      </section>
  
      <section>
        <h2>プライバシーポリシーの変更</h2>
        <p>
          当社は、必要に応じて、このプライバシーポリシーの内容を変更します。
          この場合、変更後のプライバシーポリシーの施行時期と内容を適切な方法により周知または通知します。
        </p>
      </section>
  
      <section>
        <h2>お問い合わせ</h2>
        <p>
          お客様の情報の開示、情報の訂正、利用停止、削除をご希望の場合は、以下のメールアドレスにご連絡ください。
        </p>
        <p>e-mail</p>
        <p>
          この場合、必ず、運転免許証のご提示等当社が指定する方法により、
          ご本人からのご請求であることの確認をさせていただきます。
          なお、情報の開示請求については、開示の有無に関わらず、
          ご申請時に一件あたり1,000円の事務手数料を申し受けます。
        </p>
      </section>
  
      <section>
        <h2>事業者情報</h2>
        <p>事業者の氏名: ******</p>
        <p>事業者の住所: ******</p>
        <p>2025年01月01日 制定</p>
      </section>
  </div>
  <navFooterBar />
</template>
  
  <script>
import navHeaderBar from '../components/navHeaderBar';
import navFooterBar from '../components/navFooterBar';


  export default {
    //export default内はVueの領地
    components: { 
        navHeaderBar,
        navFooterBar,
    },
    name: "Policy",
  };
  </script>
  
  <style scoped>
  .privacy-policy {
    margin: 20px;
    line-height: 1.6;
    font-family: Arial, sans-serif;
    background-color: white;
    overflow-y: auto;
    max-height: 90vh;
    padding: 20px;
    border: 1px solid #ccc;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  h1 {
    font-size: 2em;
    margin-bottom: 0.5em;
  }
  
  h2 {
    font-size: 1.5em;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
  }
  
  ul {
    list-style-type: disc;
    padding-left: 20px;
  }
  
  p {
    margin: 0.5em 0;
  }
  </style>
  
  