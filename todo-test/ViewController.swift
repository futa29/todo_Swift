//
//  ViewController.swift
//  todo-test
//
//  Created by PC089 on 2022/06/22.
//

import UIKit

//tableviewを扱うには、UITableViewDelegate, UITableViewDataSourceの二つが必要
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //tableviewに表示するために配列を作成
    var todoList = [String]()
    
    
    //保存機能の追加
    //インスタンスの生成
    let userDefaults = UserDefaults.standard
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //保存したデータを読み込み
        if let storedTodoList = userDefaults.array(forKey: "todoKey") as? [String]{
            todoList.append(contentsOf: storedTodoList)
        }
        
    }

    @IBAction func addBtnAction(_ sender: Any) {
        //アラートの設定
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください。", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField(configurationHandler: nil)
        
            //OKアクションの実装
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
                // OKをタップした時の処理
                if let textField = alertController.textFields?.first {
                    self.todoList.insert(textField.text!, at: 0)
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                    
                    //追加したTodoをユーザデフォルトに保存
                    self.userDefaults.set(self.todoList, forKey: "todoKey")
                }
            }
            //キャンセルアクションの実装
            let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        
            //実装したアクションをアラートにセット
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
        
            //そもそものアラートを表示
            present(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //配列の要素数
            return todoList.count
        }
        // ④追加：セルの中身を設定
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //セルを取得する
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
            //入力された値を表示するために値を代入
            let todoTitle = todoList[indexPath.row]
            cell.textLabel?.text = todoTitle
            
            return cell
        }
    
    
    //スワイプで削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath){
        
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.automatic)
            //削除した内容を保存
            self.userDefaults.set(todoList, forKey: "todoKey")
        
        
    }
    
    
      // スワイプした時に表示するアクションの定義
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // 編集処理
          let editAction = UIContextualAction(style: .normal, title: "編集") { (action, view, completionHandler) in
          // 編集処理を記述
          print("Editがタップされた")
            let alertController = UIAlertController(title: "ToDo編集", message: "ToDoを入力してください。", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: nil)
            
                //OKアクションの実装
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
                    // OKをタップした時の処理
                    if let textField = alertController.textFields?.first {
                        self.todoList.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with:.automatic)
                        self.todoList.insert(textField.text!, at: indexPath.row)
                        tableView.insertRows(at: [indexPath], with:.automatic)
                        
                        //追加したTodoをユーザデフォルトに保存
                        self.userDefaults.set(self.todoList, forKey: "todoKey")
                    }
                }
                //キャンセルアクションの実装
                let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
            
            
                //実装したアクションをアラートにセット
                alertController.addAction(okAction)
                alertController.addAction(cancelButton)
            
                //そもそものアラートを表示
            self.present(alertController, animated: true, completion: nil)

        // 実行結果に関わらず記述
        completionHandler(true)
        }

       // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
          //削除処理を記述
            self.todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.automatic)
            //削除した内容を保存
            self.userDefaults.set(self.todoList, forKey: "todoKey")
            
            

          // 実行結果に関わらず記述
          completionHandler(true)
        }
          
          deleteAction.image = UIImage(systemName: "trash.fill")
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
      }
    

}

